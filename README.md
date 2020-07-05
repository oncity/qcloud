# qcloud
qcloud api from ruby


Qcloud.configure do |config|
  config.app_id = 'xxxx'
  config.app_key = 'xxx'
  config.region = 'ap-beijing'
end


p Qcloud::Voice.TextToVoice('您好')

  
  
