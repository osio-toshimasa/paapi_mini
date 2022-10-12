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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/osio-toshimasa/paapi_mini. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/osio-toshimasa/paapi_mini/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PaapiMini project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/osio-toshimasa/paapi_mini/blob/master/CODE_OF_CONDUCT.md).
