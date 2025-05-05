require "ostruct"
require "byebug"
require "decidim/amazon_translate"
require "decidim/amazon_translate/version"

describe Decidim::AmazonTranslate::AmazonTranslator do
  before {
    ENV["AWS_TRANSLATE_REGION"] = 'eu-central-1'
    ENV["AWS_ACCESS_KEY_ID"] = 'XXXX'
    ENV["AWS_SECRET_ACCESS_KEY"] = 'XXXX'
    # stub amazon api call away
    allow_any_instance_of(Decidim::AmazonTranslate::AmazonTranslator).to receive(:aws_client) do
      double("AwsClient").tap do |client|
        allow(client).to receive(:translate_text) do |params|
          raise "Text cannot be empty" if params[:text].empty?
          OpenStruct.new(translated_text: params[:text].gsub(/Test/, "Bla"))
        end
      end
    end
  }

  it "has a version number" do
    expect(Decidim::AmazonTranslate.version).not_to be nil
  end

  it "works with raw text" do
    test_text = "Test Text"
    amazon_translator = Decidim::AmazonTranslate::AmazonTranslator.new("resource", "field_name", test_text, "en", "de")
    result = amazon_translator.segmented_translate
    expect(result).to eq("Bla Text")
  end
  
  it "works with html snippet and segmentation" do
    test_text = '<p class="my"><span id="x">Test</span>Text</p><p>Second Text</p>'
    amazon_translator = Decidim::AmazonTranslate::AmazonTranslator.new("resource", "field_name", test_text, "en", "de")
    result = amazon_translator.segmented_translate
    expect(result).to eq('<p class="my"><span id="x">Bla</span>Text</p><p>Second Text</p>')
  end

  it "works with long example html text with empty paragraphs" do
    test_text = "<p></p>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
<p></p>
<p>Nulla facilisi. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
<p></p>
<p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
<p></p>"
    amazon_translator = Decidim::AmazonTranslate::AmazonTranslator.new("resource", "field_name", test_text, "en", "de")

    result = amazon_translator.segmented_translate
    expect(result).to eq(test_text)
  end
end

# class AwsTranslatorTest < ActiveSupport::TestCase
#   def setup
#     @mock = ::MiniTest::Mock.new
#     def mock.aws_translate(text); text.gsub(/Test/, "Bla"); end
#   end
 
#   def test_with_raw_text
#     test_text = "Test Text"
#     AwsTranslator.stub :aws_translate, @mock do
#       aws_translator = AwsTranslator.new("resource", "field_name", test_text, "en", "de")
#       result = aws_translator.segmented_translate
#       assert_equal "Bla Text", result
#     end
#   end

#   def test_with_html_snippet
#     test_text = '<p class="my"><span id="x">Test</span>Text</p><p>Second Text</p>'
#     AwsTranslator.stub :aws_translate, @mock do
#       aws_translator = AwsTranslator.new("resource", "field_name", test_text, "en", "de")
#       result = aws_translator.segmented_translate
#       assert_equal '<p class="my"><span id="x">Bla</span>Text</p><p>Second Text</p>', result
#     end
#   end
# end
