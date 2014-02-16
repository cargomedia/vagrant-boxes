module VagrantBoxes

  class Environment

    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def find_templates
      files = Dir.glob(File.join(path, '*', '*.json'))
      files.map do |file|
        VagrantBoxes::Template.new(self, file)
      end
    end

  end
end
