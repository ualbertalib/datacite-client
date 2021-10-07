# frozen_string_literal: true

require_relative 'datacite/version'
require_relative 'datacite/doi_response'
require_relative 'datacite/client'
require_relative 'datacite/config'

# Locate, identify, and cite research data with the leading global provider of DOIs for research data.
module Datacite
  class Error < StandardError; end
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end
