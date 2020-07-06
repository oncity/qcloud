class QcloudTest < Minitest::Test
  
  def setup
  end

  def test_voice_output
    p 'voice test'
    rep = Qcloud::Voice.TextToVoice('您好')[:Response]
    assert_nil ( rep[:Error] )
  end

  def test_sms_output
    p 'sms test'
    rep = Qcloud::Sms.SmsPackagesStatistics[:Response]
    assert_nil ( rep[:Error] )

    #http://wjp2013.github.io/rails/use-minitest-in-rails/
    #assert_equal                must_equal
    #assert_instance_of      must_be_instance_of
    #assert_nil                     must_be_nil
    #assert_raises               must_raise
  end

end
