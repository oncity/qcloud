module Qcloud
  module Sms

    class << self
      def DescribeSmsSignList 
        params = {
          International: 0,
          'SignIdSet': [2174]
        }
        send_api('DescribeSmsSignList', params)
      end

      def SendSms
        params = {
          PhoneNumberSet: ['+8613702512929'],
          TemplateID: '5604',
          SmsSdkAppid: '1400019320',
          Sign: '奥视网络',
          'TemplateParamSet': [
            '1234'
          ]
        }
        send_api('SendSms', params)
      end

      def send_api(action, params)
        Qcloud.send_api(
          action: action,
          params: params,
          service: 'sms',
          host: 'sms.tencentcloudapi.com',
          version: '2019-07-11',
        )
      end
    end
  end
end
