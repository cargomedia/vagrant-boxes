module VagrantBoxes

  class Aws

    attr_accessor :key_id
    attr_accessor :key_secret

    def initialize(key_id, key_secret)
      @key_id = key_id
      @key_secret = key_secret
    end

    def s3(endpoint)
      AWS::S3.new(
          :access_key_id => key_id,
          :secret_access_key => key_secret,
          :s3_endpoint => endpoint,
      )
    end

  end
end
