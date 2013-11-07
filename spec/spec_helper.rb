require 'serverspec'
require_relative 'vagrant_helper'

include Serverspec::Helper::Ssh
include Serverspec::Helper::DetectOS


vagrant_helper = VagrantHelper.new('spec/')

RSpec.configure do |c|
  c.before :suite do
    vagrant_helper.box_add('vagrant-boxes-spec', 'current.box')
    vagrant_helper.up
    c.ssh = vagrant_helper.connect
  end

  c.after :suite do
    puts # Newline after rspec-output
    vagrant_helper.destroy
  end
end
