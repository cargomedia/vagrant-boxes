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

    def url_path(builder, version)
      raise 'Missing version' unless version
      raise 'Missing builder' unless builder
      "#{builder}/#{name}-#{version}.box"
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
      env = {'AWS_ACCESS_KEY' => environment.aws.key_id, 'AWS_SECRET_KEY' => environment.aws.key_secret}
      exec(['packer', 'build', "-only=#{builders.join(',')}", path], env)
    end

    def upload!(builders, version, s3_bucket, s3_endpoint)
      builders ||= builder_list
      s3 = environment.aws.s3(s3_endpoint)

      builders.each do |builder|
        box_path = output_path(builder)
        s3_path = url_path(builder, version)
        puts "Uploading #{s3_path} to S3..."
        s3_object = s3.buckets[s3_bucket].objects[s3_path]
        environment.add_rollback(Proc.new { s3_object.delete })
        s3_object.write(:file => box_path)
        s3_object.acl = :public_read
      end
    end

    def release_vagrant_cloud!(builders, version, url_base)
      builders ||= builder_list

      puts "Creating Vagrant Cloud box #{name} version #{version}..."
      builders.each do |builder|
        url = url_base + url_path(builder, version)
        version.ensure_provider(builder, url)
      end
      version.release
    end

    def next_version
      box = environment.vagrant_cloud.ensure_box(name)
      versions = box.versions
      if versions.empty?
        version_name = '0.1.0'
      else
        version_name = Gem::Version.new(versions.last.version).bump.to_s + '.0'
      end
      box.create_version(version_name)
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
