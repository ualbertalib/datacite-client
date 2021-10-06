# frozen_string_literal: true

require_relative 'datacite/version'
require_relative 'datacite/doi'
require_relative 'datacite/config'

module Datacite
  class Error < StandardError; end
  class << self
    def configure
      yield config
    end

    def config
      @_config ||= Config.new
    end
  end
end
