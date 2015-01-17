require 'spec_helper'

describe command('puppet --version') do
  its(:exit_status) { should eq 0 }
end

describe group('puppet') do
  it { should exist }
end

describe user('puppet') do
  it { should exist }
  it { should belong_to_group 'puppet' }
end

describe command('puppet config print | grep ssldir') do
  its(:stdout) { should eq 'ssldir = /etc/puppet/ssl' }
end
