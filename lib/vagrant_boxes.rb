module VagrantBoxes
  require 'logger'
  require 'shellwords'
  require 'json'
  require 'pathname'
  require 'fileutils'
  require 'aws-sdk'

  require 'vagrant_boxes/environment'
  require 'vagrant_boxes/template'

  def self.logger
    @logger || Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end
