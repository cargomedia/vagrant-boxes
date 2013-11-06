require 'rake'
require 'rspec/core/rake_task'
require 'pathname'

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
		commands = []
		commands << "cd #{File.dirname(template)}"
		commands << "s3cmd put #{File.dirname(template)}.box s3://s3.cargomedia.ch/vagrant-boxes/"
		commands << "s3cmd setacl --acl-public --recursive s3://s3.cargomedia.ch/vagrant-boxes/"
		system commands.join(' && ')
	  end
  end
end
