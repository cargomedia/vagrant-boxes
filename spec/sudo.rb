require 'spec_helper'

describe command('sudo whoami') do
  it { should return_stdout 'root' }
end
