module VagrantBoxes

  class Template

    attr_accessor :environment
    attr_accessor :path

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

    def exec(command)
      output = `cd #{File.dirname(template)} && #{command}`
      raise "Failure executing `#{command}`" if $? > 0
      output
    end
  end
end
