# frozen_string_literal: true

require 'aws-sdk-translate'
require 'active_support'

module Decidim
  module AmazonTranslate
    class AmazonTranslator
      attr_reader :text, :source_locale, :target_locale, :resource, :field_name
    
      def initialize(resource, field_name, text, target_locale, source_locale)
        @resource = resource
        @field_name = field_name
        @text = text
        @target_locale = target_locale
        @source_locale = source_locale
        @region = ENV['AWS_TRANSLATE_REGION'] # || Rails.application.credentials.dig(:translator, :aws_region)
        access_key_id = ENV['AWS_ACCESS_KEY_ID'] # || Rails.application.credentials.dig(:translator, :aws_access_key_id)
        secret_access_key = ENV['AWS_SECRET_ACCESS_KEY'] # || Rails.application.credentials.dig(:translator, :aws_secret_access_key)
        @credentials = ::Aws::Credentials.new(access_key_id, secret_access_key)
      end
    
      def translate
        return if @text.blank?
    
        # remove base64 encoded images if they exist
        @text.gsub!(%r{<img src=\"data:image/png;base64,.*>}, '')
        return if @text.bytesize > 10_000
    
        translation = segmented_translate
    
        Decidim::MachineTranslationSaveJob.perform_later(
          @resource,
          @field_name,
          @target_locale,
          translation
        )
      end
    
      def segmented_translate
        html = Nokogiri::HTML.fragment(@text)
    
        # get the content of each html node and translate it
        #html.xpath("//text()").each do |node|
        html.children.each do |node|
          if node.inner_html.present?
            node.inner_html = amazon_translate(node.inner_html)
          else
            node.content = amazon_translate(node.text)
          end
        end
        html.to_s
      end
    
      def amazon_translate(text)
        aws_client = Aws::Translate::Client.new(region: @region, credentials: @credentials)
        result = aws_client.translate_text(
          text: text, # required
          # terminology_names: ["ResourceName"],
          source_language_code: @source_locale, # required
          target_language_code: @target_locale, # required
          settings: {
            formality: "FORMAL", # accepts FORMAL, INFORMAL
            profanity: "MASK", # accepts MASK
          }
        )
        result.translated_text
      end
    end    
  end
end
