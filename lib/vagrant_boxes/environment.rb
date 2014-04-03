module VagrantBoxes

  class Environment

    attr_accessor :path
    attr_accessor :aws
    attr_accessor :vagrant_cloud

    def initialize(path, aws, vagrant_cloud)
      @path = path
      @aws = aws
      @vagrant_cloud = vagrant_cloud
    end

    def find_templates
      files = Dir.glob(File.join(path, '*', '*.json'))
      files.map do |file|
        VagrantBoxes::Template.new(self, file)
      end
    end

  end
end
