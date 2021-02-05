module Qcloud
  module Sms
    class Configuration
      attr_accessor :appid, :appkey, :sign
      def initialize
        @appid = ''
        @appkey = ''
        @sign = ''
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

      def packages_statistics
        # 套餐包信息统计
        params = {
          SmsSdkAppid: configuration.appid,
          Limit: 10,
          Offset: 0
        }
        p params
        send_api('SmsPackagesStatistics', params)
      end

      def describe_smssignlist
        # 短信签名状态查询
        params = {
          International: 0,
          'SignIdSet': [2174]
        }
        send_api('DescribeSmsSignList', params)
      end

      def send_sms(mobile, params)
        send_api('SendSms',
                 params.merge({
                                SmsSdkAppid: configuration.appid,
                                PhoneNumberSet: ["+86#{mobile}"],
                                Sign: configuration.sign
                              }))
      end

      def send_api(action, params)
        Qcloud.send_api(
          action: action,
          params: params,
          service: 'sms',
          host: 'sms.tencentcloudapi.com',
          version: '2019-07-11'
        )
      end
    end
  end
end
