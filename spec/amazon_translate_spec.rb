require "decidim/amazon_translate"
require "decidim/amazon_translate/version"

describe Decidim::AmazonTranslate::AmazonTranslator do
  before {
    ENV["AWS_TRANSLATE_REGION"] = 'eu-central-1'
    ENV["AWS_ACCESS_KEY_ID"] = 'XXXX'
    ENV["AWS_SECRET_ACCESS_KEY"] = 'XXXX'
  }

  it "has a version number" do
    expect(Decidim::AmazonTranslate.version).not_to be nil
  end

  it "works with raw text" do
    test_text = "Test Text"
    amazon_translator = Decidim::AmazonTranslate::AmazonTranslator.new("resource", "field_name", test_text, "en", "de")
    # stub amazon api call away
    allow(amazon_translator).to receive(:amazon_translate) do
      _1.gsub(/Test/, "Bla")
    end
    result = amazon_translator.segmented_translate
    expect(result).to eq("Bla Text")
  end
  
  it "works with html snippet and segmentation" do
    test_text = '<p class="my"><span id="x">Test</span>Text</p><p>Second Text</p>'
    amazon_translator = Decidim::AmazonTranslate::AmazonTranslator.new("resource", "field_name", test_text, "en", "de")
    # stub amazon api call away
    allow(amazon_translator).to receive(:amazon_translate) do
      _1.gsub(/Test/, "Bla")
    end
    result = amazon_translator.segmented_translate
    expect(result).to eq('<p class="my"><span id="x">Bla</span>Text</p><p>Second Text</p>')
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
