require 'net/http'
require 'net/https'
require 'uri'

module PaapiMini
module Http

  # Exception
  class Error < StandardError
    def initialize(msg = 'HttpClient Error Message.')
      super
    end
  end

  # Post
  def self.post(uri, payload, headers, options = {})
    begin
      parsed_uri, http = create_http(uri, options.has_key?(:proxy_url) ? options[:proxy_url] : nil)
      req = Net::HTTP::Post.new(parsed_uri.request_uri)

      headers.each do |key, value|
        req[key.to_s] = value.to_s
      end

      if options.has_key?(:basic_auth)
        req.basic_auth(options[:basic_auth][0], options[:basic_auth][1])
      end

      req.body = payload
      http.request(req)
    rescue => e
      raise PaapiMini::Http::Error.new("#{e.message} #{e.backtrace}" )
    end
  end

  class << self
    private

    def create_http(uri, proxy_uri)
      parsed_uri = URI.parse(uri)
      if parsed_uri.to_s == ""
        raise PaapiMini::Http::Error.new("URI parse error. uri=>#{uri}")
      end

      http = if !proxy_uri.nil? && proxy_uri.length > 0
               parsed_proxy_uri = URI.parse(proxy_uri)
               if parsed_proxy_uri.to_s == ""
                 raise PaapiMini::Http::Error.new("URI parse error. proxy_uri=>#{proxy_uri}")
               end

               # Proxy Server
               proxy_class = Net::HTTP::Proxy(parsed_proxy_uri.host.to_s, parsed_proxy_uri.port)
               proxy_class.new(parsed_uri.host, parsed_uri.port)
             else
               Net::HTTP.new(parsed_uri.host.to_s, parsed_uri.port)
             end

      http.open_timeout = 5
      http.read_timeout = 5

      if parsed_uri.scheme == 'https'
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
      [parsed_uri, http]
    end
  end
end
end