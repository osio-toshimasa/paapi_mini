require 'digest'
require 'openssl'
require 'time'
require 'uri'

module PaapiMini

  class Auth

    attr_reader :access_key,
                :secret_key,
                :path,
                :region,
                :service,
                :http_method_name,
                :headers,
                :payload,
                :xamz_date,
                :current_date,
                :signed_headers

    HMAC_ALGORITHM = 'AWS4-HMAC-SHA256'
    AWS4_REQUEST = 'aws4_request'

    public

    # Make Auth Headers Strings for Amazon Product Advertising API 5.0
    # reference: https://webservices.amazon.com/paapi5/documentation/without-sdk.html
    #            https://webservices.amazon.com/paapi5/documentation/sending-request.html#signing
    # important! https://webservices.amazon.co.jp/paapi5/scratchpad/
    def make_headers
      @headers['X-Amz-Date'] = @xamz_date
      @headers['X-Amz-Content-Sha256'] = OpenSSL::Digest::SHA256.hexdigest(@payload)

      canonical_url = prepare_canonical_request(@http_method_name, @path, @headers['X-Amz-Content-Sha256'])
      string_to_sign = prepare_string_to_sign(canonical_url)
      signature = calculate_signature(string_to_sign)
      @headers['Authorization'] = build_authorization_string(signature)
      Hash[@headers]
    end

    # URI文字列の生成
    # create_search_itemsを呼び出していないと機能しない
    def make_uri
      "https://#{@headers['Host']}#{@path}"
    end

    def prepare_canonical_request(http_method_name, path, payload)
      canonical_url = []
      uri = URI.parse(path.to_s)
      canonical_url << http_method_name
      canonical_url << "#{uri.path}\n"

      @signed_headers = []
      headers = @headers.sort_by(&:first)
      canonical_headers = []
      headers.each do |key, value|
        @signed_headers << key.downcase
        canonical_headers << "#{key.downcase}:#{value}"
      end

      canonical_url << "#{canonical_headers.join("\n")}\n"
      canonical_url << @signed_headers.join(";")
      canonical_url << payload
      canonical_url.join("\n")
    end

    def prepare_string_to_sign(canonical_url)
      string_to_sign = []
      string_to_sign << HMAC_ALGORITHM
      string_to_sign << @xamz_date
      string_to_sign << "#{@current_date}/#{@region}/#{@service}/#{AWS4_REQUEST}"
      string_to_sign << OpenSSL::Digest::SHA256.hexdigest(canonical_url)
      string_to_sign.join("\n")
    end

    def calculate_signature(string_to_sign)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), signature_key(), string_to_sign)
    end

    def build_authorization_string(signature)
      build_authorization_string = []
      build_authorization_string << "Credential=#{credentials_path}"
      build_authorization_string << "SignedHeaders=#{@signed_headers.join(";")}"
      build_authorization_string << "Signature=#{signature}"
      "#{HMAC_ALGORITHM} #{build_authorization_string.join(", ")}"
    end

    def credentials_path
      credentials = [@access_key, @current_date, region, service, AWS4_REQUEST]
      credentials.join("/")
    end

    protected


    def initialize(access_key, secret_key, path, region, service, http_method_name, headers, payload)
      @access_key, @secret_key, @path = access_key, secret_key, path
      @region, @service, @http_method_name = region, service, http_method_name
      @headers, @payload = headers, payload
      @xamz_date, @current_date = Auth::utc_timestamp(Time.now)
    end



    # https://docs.aws.amazon.com/general/latest/gr/signature-v4-examples.html#signature-v4-examples-ruby
    def signature_key
      secret = "AWS4#{@secret_key}"
      date = Auth::hmac_sha_256(secret, @current_date)
      region = Auth::hmac_sha_256(date, @region)
      service = Auth::hmac_sha_256(region, @service)
      Auth::hmac_sha_256(service, AWS4_REQUEST)
    end

    class << self

      # SearchItems
      # https://webservices.amazon.com/paapi5/documentation/search-items.html
      # SearchIndex
      # https://webservices.amazon.com/paapi5/documentation/locale-reference/japan.html
      def create_search_items(access_key,
                              secret_key,
                              partner_tag,
                              keywords:,
                              item_page: 1,
                              min_price: 1,
                              max_price: 100000,
                              min_review_rating: 1,
                              host: "webservices.amazon.co.jp",
                              region: "us-west-2",
                              market_place: "www.amazon.co.jp")

        service = 'ProductAdvertisingAPI'
        http_method_name = 'POST'
        api_path = '/paapi5/searchitems'

        headers = {}
        headers['Content-Encoding'] = 'amz-1.0'
        headers['Host'] = host
        headers['X-Amz-Target'] = 'com.amazon.paapi5.v1.ProductAdvertisingAPIv1.SearchItems'

        request_payload = <<~EOS
          {
            "Keywords": "#{keywords}",
            "Resources": [
              "BrowseNodeInfo.WebsiteSalesRank",
              "CustomerReviews.Count",
              "CustomerReviews.StarRating",
              "Images.Primary.Small",
              "Images.Primary.Medium",
              "ItemInfo.ByLineInfo",
              "ItemInfo.ContentInfo",
              "ItemInfo.ContentRating",
              "ItemInfo.Classifications",
              "ItemInfo.ManufactureInfo",
              "ItemInfo.ProductInfo",
              "ItemInfo.TechnicalInfo",
              "ItemInfo.Title",
              "ItemInfo.TradeInInfo",
              "Offers.Listings.Condition",
              "Offers.Listings.Condition.ConditionNote",
              "Offers.Listings.Condition.SubCondition",
              "Offers.Listings.DeliveryInfo.IsAmazonFulfilled",
              "Offers.Listings.DeliveryInfo.IsFreeShippingEligible",
              "Offers.Listings.DeliveryInfo.IsPrimeEligible",
              "Offers.Listings.DeliveryInfo.ShippingCharges",
              "Offers.Listings.IsBuyBoxWinner",
              "Offers.Listings.LoyaltyPoints.Points",
              "Offers.Listings.MerchantInfo",
              "Offers.Listings.Price",
              "Offers.Listings.ProgramEligibility.IsPrimeExclusive",
              "Offers.Listings.ProgramEligibility.IsPrimePantry",
              "Offers.Listings.Promotions",
              "Offers.Listings.SavingBasis",
              "Offers.Summaries.HighestPrice",
              "Offers.Summaries.LowestPrice",
              "Offers.Summaries.OfferCount",
              "ParentASIN",
              "SearchRefinements"
            ],
            "SearchIndex": "All",
            "PartnerTag": "#{partner_tag}",
            "PartnerType": "Associates",
            "Marketplace": "#{market_place}",
            "Operation": "SearchItems",
            "ItemPage": #{item_page},
            "MinReviewsRating": #{min_review_rating},
            "MinPrice": #{min_price},
            "MaxPrice": #{max_price},
            "CurrencyOfPreference":"JPY",
            "Condition":"New",
            "DeliveryFlags":["FulfilledByAmazon"]
          }
        EOS

        Auth.new(access_key, secret_key, api_path, region, service, http_method_name, headers, request_payload)
      end

      def hmac_sha_256(key, base_string)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, base_string)
      end

      def utc_timestamp(time)
        now = time.utc
        return now.strftime("%Y%m%dT%H%M%SZ"), now.strftime("%Y%m%d")
      end

    end

  end
end
