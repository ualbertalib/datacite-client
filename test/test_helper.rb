# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'datacite'

require 'minitest/autorun'
require 'vcr'
require 'pry'
require 'active_support'
require 'active_support/core_ext/object/deep_dup'

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

def unset_credentials
  username = Datacite.config.username
  password = Datacite.config.password
  Datacite.config.username = 'roger'
  Datacite.config.password = 'roger'
  [username, password]
end

def unset_password
  password = Datacite.config.password
  Datacite.config.password = 'roger'
  [Datacite.config.username, password]
end

def set_credentials(username, password)
  Datacite.config.username = username
  Datacite.config.password = password
end
