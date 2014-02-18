module VagrantBoxes

  class Environment

    attr_accessor :path
    attr_accessor :aws_key_id
    attr_accessor :aws_key_secret

    def initialize(path, aws_key_id, aws_key_secret)
      @path = path
      @aws_key_id = aws_key_id
      @aws_key_secret = aws_key_secret
    end

    def find_templates
      files = Dir.glob(File.join(path, '*', '*.json'))
      files.map do |file|
        VagrantBoxes::Template.new(self, file)
      end
    end

  end
end
