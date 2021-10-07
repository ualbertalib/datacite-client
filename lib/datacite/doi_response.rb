# frozen_string_literal: true

module Datacite
  # Datacite API v2 Response
  class DOIResponse
    def initialize(metadata)
      metadata[:data][:attributes].each do |(k, v)|
        self.class.attr_accessor(k) unless self.class.method_defined? k.to_sym
        send("#{k}=", v)
      end
    end
  end
end
