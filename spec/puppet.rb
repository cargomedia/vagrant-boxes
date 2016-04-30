require 'spec_helper'

describe command('puppet --version') do
  its(:exit_status) { should eq 0 }
end

describe command('puppet config print') do
  its(:stdout) { should match 'basemodulepath = /etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules' }
end

describe service('puppet') do
  it { should_not be_running }
end
