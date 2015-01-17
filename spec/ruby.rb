require 'spec_helper'

describe command('ruby --version') do
  its(:exit_status) { should eq 0 }
end

describe command('gem --version') do
  its(:exit_status) { should eq 0 }
end
