module Qcloud
  module Sts
    class << self
      def GetFederationToken(name, policy, duration = 7200)
        params = {
          Name: name,
          Policy: policy.to_json,
          DurationSeconds: duration
        }
        send_api('GetFederationToken', params)
      end

      def send_api(action, params)
        Qcloud.send_api(
          action: action,
          params: params,
          service: 'sts',
          host: 'sts.tencentcloudapi.com',
          version: '2018-08-13',
        )
      end
    end
  end
end
