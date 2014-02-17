module VagrantBoxes

  class Template

    attr_accessor :environment
    attr_accessor :path
    attr_accessor :data

    def initialize(environment, path)
      @environment = environment
      @path = path
    end

    def path_relative
      Pathname.new(path).relative_path_from(Pathname.new(environment.path))
    end

    def name
      path_relative.sub(/.json$/, '').to_s.sub('/', '-')
    end

    def data
      @data ||= JSON.parse(IO.read(path))
    end

    def output_path(builder)
      box_path = data['post-processors'][0]['output']
      box_path = box_path.sub('{{.BuildName}}', builder)
      File.join(File.dirname(path), box_path).to_s
    end

    def builder_list
      data['builders'].map do |builder|
        builder['name'] || builder['type']
      end
    end

    def build!(builders = nil)
      builders ||= builder_list
      builders.each do |builder|
        FileUtils.mkdir_p File.dirname(output_path(builder))
      end
      env = {:AWS_ACCESS_KEY => environment.aws_key_id, :AWS_SECRET_KEY => environment.aws_key_secret}
      exec(['packer', 'build', "-only=#{builders.join(',')}", path], env)
    end

    def upload!(builders, s3_bucket, s3_endpoint)
      builders ||= builder_list

      s3 = AWS::S3.new(
          :access_key_id => environment.aws_key_id,
          :secret_access_key => environment.aws_key_secret,
          :s3_endpoint => s3_endpoint,
      )

      builders.each do |builder|
        box_path = output_path(builder)
        s3_path = "#{builder}/#{name}.box"
        puts "Uploading #{s3_path}..."
        s3.buckets[s3_bucket].objects[s3_path].write(:file => box_path)
      end
    end

    def exec(command, env = {})
      output = ''
      Dir.chdir(File.dirname(path)) do
        io = IO.popen(env, command, :err => [:child, :out]).each do |line|
          puts line
          output += line
        end
        io.close
        if $?.exitstatus > 0
          raise "Failure executing command `#{command}`."
        end
      end
      output
    end
  end
end
