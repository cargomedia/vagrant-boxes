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

describe command('puppet config print') do
  its(:stdout) { should match 'ssldir = /etc/puppet/ssl' }
end
