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
s3_url = 'http://vagrant-boxes.cargomedia.ch/'

aws = VagrantBoxes::Aws.new(aws_key_id, aws_key_secret)
vagrant_cloud = VagrantCloud::Account.new(vagrant_cloud_username, vagrant_cloud_access_token)
environment = VagrantBoxes::Environment.new(File.dirname(__FILE__), aws, vagrant_cloud)

desc 'Build boxes'
task :build do |t|
  environment.find_templates.each do |template|
    puts "Building #{template.name}..."
    template.build!(builders)
  end
end


desc 'Upload boxes'
task :upload do |t|
  environment.find_templates.each do |template|
    puts "Uploading #{template.name}..."
    template.upload!(builders, s3_bucket, s3_endpoint)
  end
end


desc 'Validate boxes'
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
