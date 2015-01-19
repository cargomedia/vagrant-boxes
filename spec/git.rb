require 'spec_helper'

describe command('git --version') do
  its(:exit_status) { should eq 0 }
end
