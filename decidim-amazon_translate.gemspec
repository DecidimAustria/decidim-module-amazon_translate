# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/amazon_translate/version"

Gem::Specification.new do |s|
  s.version = Decidim::AmazonTranslate.version
  s.authors = ["Alexander Rusa"]
  s.email = ["alex@rusa.at"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/DecidimAustria/decidim-module-amazon_translate"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-amazon_translate"
  s.summary = "A decidim amazon_translate module"
  s.description = "Machine translations module for Amazon Translation AWS service."

  s.files = Dir["{lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", '>= 0.27.0', '< 0.29'
  s.add_dependency "aws-sdk-translate", "~> 1.59"
end
