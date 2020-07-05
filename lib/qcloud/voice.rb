module Qcloud
  module Voice

    class << self
      def TextToVoice(word)
        timestamp = Time.now.to_i.to_s
        params = {
          Text: word,
          SessionId: "session-#{timestamp}",
          Volume: 1,
          Speed: 0,
          ProjectId: 0,
          ModelType: 1,
          PrimaryLanguage: 1,
          VoiceType: 4,
          SampleRate: 16_000,
          Codec: 'wav'
        }
        send_api('TextToVoice', params)
      end

      def send_api(action, params)
        Qcloud.send_api(
          action: action,
          params: params,
          service: 'tts',
          host: 'tts.tencentcloudapi.com',
          version: '2019-08-23',
        )
      end
    end
  end
end
