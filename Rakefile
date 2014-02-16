require 'rake'
require 'rspec/core/rake_task'
require 'json'
require 'pathname'

@s3_url = 's3://s3.cargomedia.ch/vagrant-boxes/'
@builder = ENV['builder'] || 'virtualbox'
@templates = Dir.glob('*/*.json')

def box_path(template)
  template_data = JSON.parse(IO.read(template))
  box_path = template_data['post-processors'][0]['output']
  box_path.sub!('{{.Provider}}', @builder)
end

namespace :build do
  @templates.each do |template|
    template_name = template.sub(/.json$/, '')

    desc 'Build box'
    task template_name do |t|
      commands = []
      commands << "cd #{File.dirname(template)}"
      commands << "mkdir -p #{File.dirname(box_path(template))}"
      commands << "packer validate -only=#{@builder} #{File.basename(template)}"
      commands << "packer build -only=#{@builder} #{File.basename(template)}"
      system commands.join(' && ')
    end
  end
end

namespace :upload do
  @templates.each do |template|
    template_name = template.sub(/.json$/, '')

    desc 'Upload box'
    task template_name do |t|
      raise 'Uploading is only supported for virtualbox-builder' if @builder != 'virtualbox'
      box_path = box_path(template)
      s3_path = File.basename(box_path)

      commands = []
      commands << "cd #{File.dirname(template)}"
      commands << "s3cmd put #{box_path} #{@s3_url}#{s3_path}"
      commands << "s3cmd setacl --acl-public #{@s3_url}#{s3_path}"
      system commands.join(' && ')
    end
  end
end

namespace :spec do
  @templates.each do |template|
    template_name = template.sub(/.json$/, '')

    desc 'Validate box'
    RSpec::Core::RakeTask.new(template_name) do |t|
      box_path = box_path(template)
      box_path_absolute = Pathname.new(File.join(File.dirname(template), box_path)).realpath.to_s

      File.delete('spec/current.box') if File.exists?('spec/current.box')
      File.symlink(box_path_absolute, 'spec/current.box')

      if 'plain' == File.basename(template_name)
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb')
      else
        t.pattern = FileList.new('spec/filesystem.rb', 'spec/sudo.rb', 'spec/git.rb', 'spec/ruby.rb', 'spec/puppet.rb')
      end
    end
  end
end
