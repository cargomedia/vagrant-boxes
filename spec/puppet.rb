require 'spec_helper'

describe command('puppet --version') do
  it { should return_exit_status 0 }
end
