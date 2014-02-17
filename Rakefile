$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'rspec/core/rake_task'
require 'json'
require 'pathname'
require 'fileutils'

require 'vagrant_boxes'

@s3_url = 's3://s3.cargomedia.ch/vagrant-boxes/'
@builder = ENV['builder'] || 'virtualbox'
builders = ENV.has_key?('builder') ? [ENV['builder']] : nil
aws_key_id = ENV['aws_key_id']
aws_key_secret = ENV['aws_key_secret']

environment = VagrantBoxes::Environment.new(File.dirname(__FILE__), aws_key_id, aws_key_secret)

namespace :build do
  environment.find_templates.each do |template|
    desc 'Build box'
    task template.name do |t|
      template.build!(builders)
    end
  end
end

namespace :upload do
  environment.find_templates.each do |template|
    desc 'Upload box'
    task template.name do |t|
      template.upload!(builders, 'vagrant-boxes.cargomedia.ch', 's3-eu-west-1.amazonaws.com')
    end
  end
end

namespace :spec do
  environment.find_templates.each do |template|
    desc 'Validate box'
    RSpec::Core::RakeTask.new(template.name) do |t|
      box_path = template.output_path('virtualbox')

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
