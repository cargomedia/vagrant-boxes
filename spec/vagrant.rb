require 'spec_helper'

describe user('vagrant') do
  it { should exist }
  it { should belong_to_group 'sudo' }
end
