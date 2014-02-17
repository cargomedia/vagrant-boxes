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
      path_relative.sub(/.json$/, '').to_s
    end

    def data
      @data ||= JSON.parse(IO.read(path))
    end

    def output_path(builder)
      box_path = data['post-processors'][0]['output']
      box_path = box_path.sub('{{.Provider}}', builder)
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
      exec(['packer', 'build', "-only=#{builders.join(',')}", path])
    end

    def exec(command)
      output = ''
      Dir.chdir(File.dirname(path)) do
        io = IO.popen(command, :err => [:child, :out]).each do |line|
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
