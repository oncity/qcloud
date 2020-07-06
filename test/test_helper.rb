#$LOAD_PATH << "./lib" # 把lib添加到load path

require 'minitest/autorun'  # 引进minitest
require 'qcloud'

Qcloud.configure do |config|
  config.app_id = ENV['QCLOUD_APP_ID']
  config.app_key = ENV['QCLOUD_APP_KEY']
  config.region = 'ap-beijing'
end
