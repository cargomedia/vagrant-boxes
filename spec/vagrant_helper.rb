require 'shellwords'
require 'net/ssh'
require 'tempfile'

class VagrantHelper

  def initialize(working_dir)
    @working_dir = working_dir
  end

  def command(subcommand)
    puts "vagrant #{subcommand}"
    `cd #{@working_dir} && vagrant #{subcommand}`
  end

  def box_add(name, path)
    if system("vagrant box list | grep -q '^#{name.shellescape} '")
      command "box remove #{name.shellescape}"
    end
    command "box add #{name.shellescape} #{path.shellescape}"
  end

  def up
    command 'up'
  end

  def destroy
    command 'destroy --force'
  end

  def ssh_options
    config = Tempfile.new('')
    command("ssh-config > #{config.path}")
    Net::SSH::Config.for('default', [config.path])
  end

end
