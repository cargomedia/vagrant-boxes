require 'spec_helper'

describe command('puppet --version') do
  it { should return_exit_status 0 }
end

describe group('puppet') do
  it { should exist }
end

describe user('puppet') do
  it { should exist }
  it { should belong_to_group 'puppet' }
end
