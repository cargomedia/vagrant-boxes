require 'serverspec'
require_relative 'vagrant_helper'

vagrant_helper = VagrantHelper.new('spec/')

RSpec.configure do |c|
  c.before :suite do
    vagrant_helper.box_add('vagrant-boxes-spec', 'current.box')
    vagrant_helper.up

    Specinfra.configuration.backend = :ssh
    Specinfra.configuration.ssh_options = vagrant_helper.ssh_options
  end

  c.after :suite do
    puts # Newline after rspec-output
    vagrant_helper.destroy
  end
end
