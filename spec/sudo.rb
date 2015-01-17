require 'spec_helper'

describe command('sudo whoami') do
  its(:stdout) { should eq "root\n" }
end
