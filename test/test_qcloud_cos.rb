class QcloudTest < Minitest::Test

  #https://docs.aws.amazon.com/sdk-for-ruby/v3/api/
  
  def setup
    Qcloud::Cos.configure do |config|
      config.region = 'ap-beijing'
      config.bucket = 'content-1251050460'
      config.uid = '1251050460'
    end
  end

  def test_list

    p 'cos list test'

    fn = '/cos_test.txt'
    body = 'abcdefg'

    rep = Qcloud::Cos.put_object(fn,body)
    #Aws::S3::Errors::NoSuchKey

    rep = Qcloud::Cos.get_object(fn)
    assert_equal rep.get.body.read,body

    Qcloud::Cos.delete_object(fn)

    assert_equal Qcloud::Cos.exists_object?(fn) , false

    bucket = 'content-1251050460'
    allow_actions = [
      "name/cos:PutObject"
    ]
    allow_prefixs = [
      "/sysop","/img"
    ]

    p Qcloud::Cos.sts_key(bucket,allow_actions,allow_prefixs)

  end


end
