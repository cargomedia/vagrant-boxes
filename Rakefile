$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'rspec/core/rake_task'
require 'vagrant_boxes'

builders = ENV.has_key?('builder') ? [ENV['builder']] : nil
aws_key_id = ENV['aws_key_id']
aws_key_secret = ENV['aws_key_secret']
vagrant_cloud_username = ENV['vagrant_cloud_username']
vagrant_cloud_access_token = ENV['vagrant_cloud_access_token']
s3_bucket = 'vagrant-boxes.cargomedia.ch'
s3_endpoint = 's3-eu-west-1.amazonaws.com'
url_base = 'http://vagrant-boxes.cargomedia.ch/'

aws = VagrantBoxes::Aws.new(aws_key_id, aws_key_secret)
vagrant_cloud = VagrantCloud::Account.new(vagrant_cloud_username, vagrant_cloud_access_token)
environment = VagrantBoxes::Environment.new(File.dirname(__FILE__), aws, vagrant_cloud)

desc 'Build all boxes'
task :build do |t|
  environment.find_templates.each do |template|
    puts "Building #{template.name}..."
    template.build!(builders)
  end
end

desc 'Run serverspec tests (virtualbox build only!)'
task :spec do |t|
  environment.find_templates.each do |template|
    puts "Validating #{template.name}..."
    task = RSpec::Core::RakeTask.new(template.name)
    box_path = template.output_path('virtualbox')

    File.delete('spec/current.box') if File.symlink?('spec/current.box')
    File.symlink(box_path, 'spec/current.box')

    if File.basename(template.name).match(/plain$/)
      task.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb')
    else
      task.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb', 'spec/git.rb', 'spec/ruby.rb', 'spec/puppet.rb')
    end

    task.run_task(true)
  end
end

desc 'Release boxes to S3 and Vagrant Cloud'
task :release do |t|
  environment.find_templates.each do |template|
    version = template.next_version
    environment.add_rollback(Proc.new { version.delete })
    puts "Releasing #{template.name} version #{version}..."
    begin
      #template.upload!(builders, version, s3_bucket, s3_endpoint)
      template.release_vagrant_cloud!(builders, version, url_base)
    rescue Exception => e
      environment.rollback
      throw e
    end
  end
end
