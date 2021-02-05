class QcloudTest < Minitest::Test

  #https://docs.aws.amazon.com/sdk-for-ruby/v3/api/
  def setup
    Qcloud::Sms.configure do |config|
      config.appid = '1400484373'
      config.appkey = ''
      config.sign = '开大联盟'
    end
  end

  def test_list
    p Qcloud::Sms.packages_statistics
=begin
    params = {
      TemplateID: '865788',
      'TemplateParamSet': [
        'a', 'b', 'c'
      ]
    }
    p Qcloud::Sms.send_sms('13702512929', params)
=end
  end
end
