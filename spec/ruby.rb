require 'spec_helper'

describe command('ruby --version') do
  it { should return_exit_status 0 }
end

describe command('gem --version') do
  it { should return_exit_status 0 }
end
