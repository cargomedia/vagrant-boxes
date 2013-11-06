require 'rake'
require 'rspec/core/rake_task'
require 'json'
require 'pathname'

s3_url = 's3://s3.cargomedia.ch/vagrant-boxes/'
templates = Dir.glob('*/*.json')

namespace :build do
  templates.each do |template|
    template_name = template.sub(/.json$/, '')

    desc 'Build box'
    task template_name do |t|
      commands = []
      commands << "cd #{File.dirname(template)}"
      commands << "packer validate #{File.basename(template)}"
      commands << "packer build #{File.basename(template)}"
      system commands.join(' && ')
    end
  end
end

namespace :upload do
  templates.each do |template|
    template_name = template.sub(/.json$/, '')
    template_data = JSON.parse(IO.read(template))
    filename = template_data['post-processors'][0]['output']

    desc 'Upload box'
    task template_name do |t|
      commands = []
      commands << "cd #{File.dirname(template)}"
      commands << "s3cmd put #{filename} #{s3_url}#{filename}"
      commands << "s3cmd setacl --acl-public #{s3_url}#{filename}"
      system commands.join(' && ')
    end
  end
end

namespace :spec do
  templates.each do |template|
    template_name = template.sub(/.json$/, '')


    desc 'Validate box'
    RSpec::Core::RakeTask.new(template_name) do |t|
      require_relative 'spec/vagrant_helper'
      template_data = JSON.parse(IO.read(template))
      box_filename = template_data['post-processors'][0]['output']
      box_path = Pathname.new(File.join(File.dirname(template), box_filename)).realpath.to_s
      File.delete('spec/current.box') if File.exists?('spec/current.box')
      File.symlink(box_path, 'spec/current.box')
      t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb', 'spec/git.rb', 'spec/ruby.rb', 'spec/puppet.rb')
    end
  end
end
