# frozen_string_literal: true

require_relative 'datacite/version'
require_relative 'datacite/doi_response'
require_relative 'datacite/client'

# Locate, identify, and cite research data with the leading global provider of DOIs for research data.
#
# ---
#
# Configures global settings for Datacite
#   Datacite.configure do |config|
#     config.host = ENV['DATACITE_HOST'] || 'api.test.datacite.org'
#     config.username = ENV['DATACITE_USERNAME']
#     config.password = ENV['DATACITE_PASSWORD']
#     config.prefix = ENV['DATACITE_PREFIX']
#   end
module Datacite
  # This is a general catch all for Datacite errors
  class Error < StandardError; end

  # This is an error for when the request body given is not processable
  class UnprocessableError < Error; end

  # This is an error for when the target is not found or the credentials are missing
  class NotFoundError < Error; end

  # This is an error for when the credentials given are unauthorized
  class UnauthorizedError < Error; end

  # https://support.datacite.org/docs/doi-states
  class State
    DRAFT = 'draft'
    FINDABLE = 'findable'
    REGISTERED = 'registered'
  end

  # Corresponds to the action you want to trigger for the DOI.
  # https://support.datacite.org/docs/api-create-dois -- A word on states - publishing to findable
  class Event
    PUBLISH = 'publish'
    REGISTER = 'register'
    HIDE = 'hide'
  end

  class << self
    # Datacite.configure takes a block to configure global settings
    def configure
      yield config
    end

    # makes the configuration object a singleton
    def config
      @config ||= Config.new
    end
  end

  # Datacite Client Configuration
  class Config
    attr_accessor :host, :username, :password, :prefix

    #
    # Creates a <tt>Config</tt> object and sets values from env vars
    #
    # Can be modified from <tt>Datacite.configure</tt> block
    #
    def initialize
      @host = ENV['DATACITE_HOST'] || 'api.test.datacite.org'
      @username = ENV['DATACITE_USERNAME']
      @password = ENV['DATACITE_PASSWORD']
      @prefix = ENV['DATACITE_PREFIX']
    end
  end
end
