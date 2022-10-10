# frozen_string_literal: true

require_relative "paapi_mini/version"
require_relative 'aws_v4_auth'
require_relative 'http_client'

module PaapiMini
  class Error < StandardError; end

  def self.search_items(access_key,
                       secret_key,
                       partner_tag,
                       keywords,
                       item_page: 1,
                       min_price: 1,
                       max_price: 100000,
                       min_review_rating: 1,
                       host: "webservices.amazon.co.jp",
                       region: "us-west-2",
                       market_place: "www.amazon.co.jp")

    aws_auth = Auth.create_search_items(access_key,
                                        secret_key,
                                        partner_tag,
                                        keywords: keywords,
                                        item_page: item_page,
                                        min_price: min_price,
                                        max_price: max_price,
                                        min_review_rating: min_review_rating,
                                        host: host,
                                        region: region,
                                        market_place: market_place)

    aws_auth_headers = aws_auth.make_headers
    aws_auth_headers['Content-Type'] = 'application/json; charset=utf-8'

    return Http.post(aws_auth.make_uri, aws_auth.payload, aws_auth_headers)
  end


end
