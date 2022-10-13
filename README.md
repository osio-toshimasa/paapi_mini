# PaapiMini

* This is a Gem for easy Amazon product search.<br>
Before using it, you need to pass Amazon Associate review and get ACCESS_KEY etc. as preparation.
* [Amazon Product Advertising API 5.0](https://webservices.amazon.com/paapi5/documentation/)　is supported.
* This Gem is implemented using only the Ruby standard-attached library, so it does not depend on other Gems.

* Ruby versions that have been tested by rbenv
```
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin20]
ruby 3.0.0rc1 (2020-12-20 master 8680ae9cbd) [x86_64-darwin20]
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]
```
* We have not tested Ruby for Windows at this time.<br>
Also, since the author's Amazon Associate review is conducted by Amazon.co.jp, we are only able to test from this region.<br>
Therefore, the default behavior of the API is Amazon.co.jp. It is possible to change it with an argument.<br>
We would appreciate it if you could provide us with feedback if you can confirm that it works on the Windows version or in regions other than Amazon.co.jp.

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

    # The keyword argument to the search_items method can be used to refine the condition.
    # Please refer to the official reference for the specifications of each argument.
    # See Also https://webservices.amazon.com/paapi5/documentation/search-items.html
    # Default Values.
    # item_page: 1,
    # min_price: 1,
    # max_price: 100000,
    # min_review_rating: 1,
    # host: "webservices.amazon.co.jp",
    # region: "us-west-2",
    # market_place: "www.amazon.co.jp"
    
    res = PaapiMini::search_items(ENV['ACCESS_KEY'], ENV['SECRET_KEY'], ENV['PARTNER_TAG'],
                                  keywords: "Ruby", min_review_rating: 3)

    # res is Net::HTTPResponse Object
    # See Also https://docs.ruby-lang.org/
    puts res.code
    puts res.body
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).