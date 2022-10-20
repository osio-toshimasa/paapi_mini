# PaapiMini

* 英語用READMEはこちら [README.md](./README.md)
* このGemhaAmazonの商品検索を行います。<br>
  使用前にAmazonアソシエイト審査に合格し、アクセスキーなどの発行をしておく必要があります。
* [Amazon Product Advertising API 5.0](https://webservices.amazon.com/paapi5/documentation/)をサポートしています。
* このGemはRuby標準ライブラリのみで実装されています。このため他のGemに依存することなく利用することができます。

* rbenvを使って以下のRubyバージョンでテストを行いました。
```
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin20]
ruby 3.0.0rc1 (2020-12-20 master 8680ae9cbd) [x86_64-darwin20]
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]
```
* Windows環境ではテストできていません。<br>
  また、筆者のAmazonアソシエイト審査はAmazon.co.jpで行われているため、この地域からのテストしかできません。<br>
　そのため、APIのデフォルト動作はAmazon.co.jpになっています。引数で変更することは可能です。<br>
　Windows版やAmazon.co.jp以外の地域で動作が確認できた場合は、フィードバックしていただけると幸いです。

## インストール

アプリケーションのGemfileに次の行を追加します。

```ruby
gem 'paapi_mini'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install paapi_mini

## 使い方

```ruby
    require 'paapi_mini'

    # search_items メソッドのキーワード引数で、条件を絞り込むことができる。
    # search_itemsの詳細はAmazon公式サイトをご参照ください。
    # 参考 https://webservices.amazon.com/paapi5/documentation/search-items.html
    # 各引数のデフォルト値
    # item_page: 1,
    # min_price: 1,
    # max_price: 100000,
    # min_review_rating: 1,
    # host: "webservices.amazon.co.jp",
    # region: "us-west-2",
    # market_place: "www.amazon.co.jp"
    
    res = PaapiMini::search_items(ENV['ACCESS_KEY'], ENV['SECRET_KEY'], ENV['PARTNER_TAG'],
                                  keywords: "Ruby", min_review_rating: 3)

    # res は Net::HTTPResponse オブジェクトです。
    # Net::HTTPResponseについては、Ruby公式リファレンスマニュアルを参照ください。 https://docs.ruby-lang.org/
    puts res.code
    puts res.body
```

## ライセンス

このGemのライセンスは [MIT License](https://opensource.org/licenses/MIT)となります。

## このGemが気に入ってくれたら、ご協力お願いします。

* 現在、開発が停止しています。 Amazonアソシエイトの販売実績が３０日間発生しないと、APIの応答結果がエラーになってしまうためです。
* もしこのGemを気に入ってくれた方がいましたら、[こちらのリンク](https://amzn.to/3Ta7pvV)からAmazon商品を買っていただけると助かります。
* 値段は関係なく、このリンクから辿った別の商品でも問題ないです。
* 販売実績を達成しAPI制限が解放されたら、get_itemsなど他のAPIサポートなどの実装を行いたいと思います。