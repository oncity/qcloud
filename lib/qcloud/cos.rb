module Qcloud
  module Cos
    # https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/welcome.html
    class Configuration
      attr_accessor :region, :bucket
      def initialize
        @region = ''
        @bucket = ''
      end
    end

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
        Aws.config.update({
          region: configuration.region,
          credentials: Aws::Credentials.new(Qcloud.configuration.app_id, Qcloud.configuration.app_key),
          endpoint: "https://cos.#{configuration.region}.myqcloud.com"
        })
      end

      def s3
        @s3_resource ||= Aws::S3::Resource.new
      end

      def get_bucket_object(name,bucket_name)
        bucket = s3.bucket(bucket_name || configuration.bucket)
        bucket.object(name)
      end

      def put_object(name,body,bucket_name=nil)
        #s3.put_object(bucket: bucket, key: name , body: bodyect")
        obj = get_bucket_object(name, bucket_name)
        obj.put(body:body)
      end

      def exists_object?(name,bucket_name=nil)
        obj = get_bucket_object(name, bucket_name)
        obj.exists?
      end

      def delete_object(name,bucket_name=nil)
        obj = get_bucket_object(name, bucket_name)
        obj.delete if obj.exists?
      end

      def get_object(name,bucket_name=nil)
        obj = get_bucket_object(name, bucket_name)
        obj.exists? ? obj : nil
=begin
bucket.objects.each do |obj|
  puts "#{obj.key} => #{obj.etag}"
end

# batch operations, delete objects in batches of 1k
bucket.objects(prefix: '/tmp-files/').delete

# single object operations
obj = bucket.object('hello')


obj.put(body:'Hello World!')
obj.etag
obj.delete
=end
      end

    end
  end
end
