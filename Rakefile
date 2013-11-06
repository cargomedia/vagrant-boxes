require 'rake'
require 'rspec/core/rake_task'
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
	  desc 'Upload box'
	  task template_name do |t|
	  	s3_path = s3_url + File.dirname(template)
	  	if 'default' != File.basename(template_name)
	  		s3_path += '-' + File.basename(template_name)
	  	end
	  	s3_path += '.box'
		commands = []
		commands << "cd #{File.dirname(template)}"
		commands << "s3cmd put #{File.basename(template_name)}.box #{s3_path}"
		commands << "s3cmd setacl --acl-public #{s3_path}"
		system commands.join(' && ')
	  end
  end
end
