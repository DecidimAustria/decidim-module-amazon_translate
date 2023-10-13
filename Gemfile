# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim-core", '>= 0.27.0', '< 0.28'
gem "aws-sdk-translate", '~> 1.59'
gem "decidim-amazon_translate", path: "."

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "rspec"
end

