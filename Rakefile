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

def box_path(template)
  template_data = JSON.parse(IO.read(template))
  box_path = template_data['post-processors'][0]['output']
  box_path.sub!('{{.Provider}}', @builder)
end

def template_exec(template, command)
  output = `cd #{File.dirname(template)} && #{command}`
  raise "Failure executing `#{command}`" if $? > 0
  output
end

namespace :build do
  environment.find_templates.each do |template|
    desc 'Build box'
    task template.name do |t|
      artifacts_dir = File.dirname(box_path(template.path))
      FileUtils.mkdir_p artifacts_dir
      template_exec(template.path, "packer build -only=#{@builder} #{File.basename(template.path)}")
    end
  end
end

namespace :upload do
  environment.find_templates.each do |template|
    desc 'Upload box'
    task template.name do |t|
      raise 'Uploading is only supported for virtualbox-builder' if @builder != 'virtualbox'
      box_path = box_path(template.path)
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
      box_path = box_path(template.path)
      box_path_absolute = Pathname.new(File.join(File.dirname(template.path), box_path)).realpath.to_s

      File.delete('spec/current.box') if File.exists?('spec/current.box')
      File.symlink(box_path_absolute, 'spec/current.box')

      if 'plain' == File.basename(template.name)
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb')
      else
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb', 'spec/git.rb', 'spec/ruby.rb', 'spec/puppet.rb')
      end
    end
  end
end
