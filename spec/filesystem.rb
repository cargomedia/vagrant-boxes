require 'spec_helper'

describe command('echo "hello world" > /tmp/foo') do
  its(:exit_status) { should eq 0 }
end

describe file('/tmp/foo') do
  its(:content) { should match /^hello world$/ }
end
