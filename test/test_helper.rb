# frozen_string_literal: true

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
