module VagrantBoxes

  class Environment

    attr_accessor :path
    attr_accessor :aws
    attr_accessor :vagrant_cloud

    def initialize(path, aws, vagrant_cloud)
      @path = path
      @aws = aws
      @vagrant_cloud = vagrant_cloud
      @rollback_procs = []
    end

    # @param [String] name_filter
    # @return [Array<VagrantBoxes::Template>]
    def find_templates(name_filter = nil)
      name_regex = Regexp.new(name_filter) unless name_filter.nil?
      files = Dir.glob(File.join(path, '*', '*.json'))
      templates = files.map do |file|
        VagrantBoxes::Template.new(self, file)
      end
      templates = templates.select { |template| template.name =~ name_regex } unless name_regex.nil?
      templates
    end

    def add_rollback(proc)
      @rollback_procs.push(proc)
    end

    def rollback
      count = @rollback_procs.count
      @rollback_procs.each_with_index do |proc, index|
        begin
          print "Starting rollback #{index+1}/#{count}... "
          proc.call
          puts "done."
        rescue Exception => e
          puts "failed. (#{e})"
        end
      end
      @rollback_procs = []
    end

  end
end
