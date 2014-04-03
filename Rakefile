$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'rspec/core/rake_task'
require 'vagrant_boxes'

@s3_url = 's3://s3.cargomedia.ch/vagrant-boxes/'
@builder = ENV['builder'] || 'virtualbox'
builders = ENV.has_key?('builder') ? [ENV['builder']] : nil

aws = VagrantBoxes::Aws.new(ENV['aws_key_id'], ENV['aws_key_secret'])
vagrant_cloud = VagrantCloud::Account.new(ENV['vagrant_cloud_username'], ENV['vagrant_cloud_access_token'])
environment = VagrantBoxes::Environment.new(File.dirname(__FILE__), aws, vagrant_cloud)

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
      #template.upload!(builders, 'vagrant-boxes.cargomedia.ch', 's3-eu-west-1.amazonaws.com')
      p vagrant_cloud.ensure_box('foo6', 'njam')
      #p vagrant_cloud.version_ensure('foo4', '0.0.3', 'njam')
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

      if File.basename(template.name).match(/plain$/)
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb')
      else
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb', 'spec/git.rb', 'spec/ruby.rb', 'spec/puppet.rb')
      end
    end
  end
end
