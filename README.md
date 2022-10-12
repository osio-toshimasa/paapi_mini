# PaapiMini

This is a Gem for easy Amazon product search.<br>
Before using it, you need to pass Amazon Associate review and get ACCESS_KEY etc. as preparation.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paapi_mini'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install paapi_mini

## Usage

```ruby
    require 'paapi_mini'

    res = PaapiMini::search_items(ENV['ACCESS_KEY'], ENV['SECRET_KEY'], ENV['PARTNER_TAG'], "Ruby")

    # ResponseData is Net::HTTPResponse Object
    puts res.code
    puts res.body
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).