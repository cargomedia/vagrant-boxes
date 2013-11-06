require 'shellwords'
require 'net/ssh'

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

  def connect
    user = Etc.getlogin
    options = {}
    host = ''
    config = command 'ssh-config'
    config.each_line do |line|
      if match = /HostName (.*)/.match(line)
        host = match[1]
        options = Net::SSH::Config.for(host)
      elsif  match = /User (.*)/.match(line)
        user = match[1]
      elsif match = /IdentityFile (.*)/.match(line)
        options[:keys] = [match[1].gsub(/"/, '')]
      elsif match = /Port (.*)/.match(line)
        options[:port] = match[1]
      end
    end
    @connection = Net::SSH.start(host, user, options)
  end

end
