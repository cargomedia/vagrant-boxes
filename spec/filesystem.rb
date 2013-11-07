require 'spec_helper'

describe command('echo "hello world" > /tmp/foo') do
  it { should return_exit_status 0 }
end

describe file('/tmp/foo') do
  its(:content) { should match /^hello world$/ }
end
