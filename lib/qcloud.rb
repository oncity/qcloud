require 'json'
require 'digest'
require 'rest-client'
require 'aws-sdk-s3'

require_relative 'qcloud/sms'
require_relative 'qcloud/voice'
require_relative 'qcloud/sts'
require_relative 'qcloud/cos'

module Qcloud

  class Configuration
    attr_accessor :app_id, :app_key, :region
    def initialize
      @app_id = ''
      @app_key = ''
      @region = ''
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def sign(key, msg)
      digest = OpenSSL::Digest.new('sha256')
      OpenSSL::HMAC.digest(digest, key, msg)
    end

    def send_api(data, debug = false)
      timestamp = Time.now.to_i.to_s
      date = Time.now.utc.strftime('%Y-%m-%d')

      algorithm = 'TC3-HMAC-SHA256'
      http_request_method = 'POST'
      canonical_uri = '/'
      canonical_querystring = ''
      ct = 'application/json'

      payload = data[:params].to_json
      p payload if debug

      canonical_headers = "content-type:#{ct}\nhost:#{data[:host]}\n"
      signed_headers = 'content-type;host'

      hashed_request_payload = Digest::SHA256.hexdigest(payload)

      canonical_request = (http_request_method + "\n" +
                           canonical_uri + "\n" +
                           canonical_querystring + "\n" +
                           canonical_headers + "\n" +
                           signed_headers + "\n" +
                           hashed_request_payload)
      p canonical_request if debug

      credential_scope = date + '/' + data[:service] + '/' + 'tc3_request'
      hashed_canonical_request = Digest::SHA256.hexdigest(canonical_request)
      string_to_sign = algorithm + "\n" +
        timestamp + "\n" +
        credential_scope + "\n" +
        hashed_canonical_request
      p string_to_sign if debug

      secret_date = sign('TC3' + configuration.app_key, date)
      secret_service = sign(secret_date, data[:service])
      secret_signing = sign(secret_service, 'tc3_request')
      signature =  Digest.hexencode( OpenSSL::HMAC.digest( OpenSSL::Digest.new('sha256') , secret_signing , string_to_sign ) )

      p signature if debug

      # ************* 步骤 4：拼接 Authorization *************
      authorization = algorithm + ' ' +
        'Credential=' + configuration.app_id + '/' + credential_scope + ', ' +
        'SignedHeaders=' + signed_headers + ', ' +
        'Signature=' + signature
      p authorization if debug

      data = RestClient.post("https://#{data[:host]}",payload , {
        Authorization: authorization,
        'X-TC-Action': data[:action],
        'X-TC-Timestamp': timestamp,
        'X-TC-Version': data[:version],
        'X-TC-Region': configuration.region,
        'Content-Type': 'application/json',
        'X-TC-Language': 'zh-CN',
      })

      JSON.parse(data, symbolize_names: true)
    end
  end
end
