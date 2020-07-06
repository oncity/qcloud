module Qcloud
  module Cos
    # https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/welcome.html
    class Configuration
      attr_accessor :region, :bucket, :uid
      def initialize
        @region = ''
        @bucket = ''
        @uid = ''
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
      end

      def sts_key(bucket,allow_actions,allow_prefixs)

        resource = allow_prefixs.map do |p|
          "qcs::cos:#{configuration.region}:uid/#{configuration.uid}:#{bucket}#{p}"
        end

        policy = {
          'version': '2.0',
          'statement': [
            {
              'action': allow_actions,
              'effect': 'allow',
              'resource': resource
            }
          ]
        }
        Qcloud::Sts::GetFederationToken('cos-sts-key',policy, 7200 )
      end

    end
  end
end
