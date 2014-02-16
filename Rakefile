$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'rspec/core/rake_task'
require 'json'
require 'pathname'
require 'fileutils'

require 'vagrant_boxes'

@s3_url = 's3://s3.cargomedia.ch/vagrant-boxes/'
@builder = ENV['builder'] || 'virtualbox'

environment = VagrantBoxes::Environment.new(File.dirname(__FILE__))

namespace :build do
  environment.find_templates.each do |template|
    desc 'Build box'
    task template.name do |t|
      artifacts_dir = File.dirname(template.output_path(@builder))
      FileUtils.mkdir_p artifacts_dir
      template.exec("packer build -only=#{@builder} #{File.basename(template.path)}")
    end
  end
end

namespace :upload do
  environment.find_templates.each do |template|
    desc 'Upload box'
    task template.name do |t|
      raise 'Uploading is only supported for virtualbox-builder' if @builder != 'virtualbox'
      box_path = template.output_path(@builder)
      s3_path = File.basename(box_path)

      commands = []
      commands << "cd #{File.dirname(template.path)}"
      commands << "s3cmd put #{box_path} #{@s3_url}#{s3_path}"
      commands << "s3cmd setacl --acl-public #{@s3_url}#{s3_path}"
      system commands.join(' && ')
    end
  end
end

namespace :spec do
  environment.find_templates.each do |template|
    desc 'Validate box'
    RSpec::Core::RakeTask.new(template.name) do |t|
      box_path = template.output_path(@builder)

      File.delete('spec/current.box') if File.exists?('spec/current.box')
      File.symlink(box_path, 'spec/current.box')

      if 'plain' == File.basename(template.name)
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb')
      else
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb', 'spec/git.rb', 'spec/ruby.rb', 'spec/puppet.rb')
      end
    end
  end
end
