
require 'http'
require 'byebug'
require "dotenv"

Dotenv.load
# Version
require 'avostart/version'

# API operations
require 'avostart/api_operations/create'
require 'avostart/api_operations/request'
require 'avostart/api_operations/list'

# API resource support classes
require 'avostart/errors'
require 'avostart/object_types'
require 'avostart/avostart_object'
require 'avostart/api_resource'
require 'avostart/util'
require 'avostart/list_object'
require 'avostart/avostart_client'
require 'avostart/avostart_response'

# Named API resources
require 'avostart/resources'

module Avostart
  @api_base = 'https://partners-api.staging.avostart.fr'
  @client_id = ENV['CLIENT_ID']
  @client_secret = ENV['CLIENT_SECRET']
  class << self
    attr_accessor :avostart_account, :api_base, :client_id, :client_secret
  end
end