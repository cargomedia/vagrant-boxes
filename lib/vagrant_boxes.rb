module VagrantBoxes
  require 'logger'
  require 'shellwords'
  require 'json'
  require 'pathname'
  require 'fileutils'
  require 'aws-sdk'
  require 'rest_client'

  require 'vagrant_boxes/environment'
  require 'vagrant_boxes/template'
  require 'vagrant_boxes/aws'
  require 'vagrant_cloud/account'
  require 'vagrant_cloud/box'
  require 'vagrant_cloud/version'
  require 'vagrant_cloud/provider'

  def self.logger
    @logger || Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end
