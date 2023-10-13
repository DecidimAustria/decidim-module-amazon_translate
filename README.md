# Decidim::AmazonTranslate

Machine translations module for Amazon Translation AWS service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-amazon_translate"
```

## Usage

Update config/initializers/decidim.rb to contain:

```ruby
config.machine_translation_service = "Decidim::AmazonTranslate::AwsTranslator"
```

Make sure you have AWS credentials in your environment variables or rails credentials:

Environment variables example:

```sh
AWS_TRANSLATE_REGION="eu-central-1"
AWS_ACCESS_KEY_ID="XXXXXX"
AWS_SECRET_ACCESS_KEY="XXXXXX"
```

Rails credentials example:

```yaml
translator:
  aws_region: "eu-central-1"
  aws_access_key_id: "XXXXXX"
  aws_secret_access_key: "XXXXXX"
```

And then enable machine translations in the admin webinterface settings.

Find more documentation on the general machine translation feature in the decidim documentation:

https://docs.decidim.org/en/develop/develop/machine_translations.html

## Contributing

Feel free to open issues or pull requests.

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
