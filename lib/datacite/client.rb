# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

EMPTY_METADATA_HASH =
  {
    data: {
      attributes: {}
    }
  }.freeze

module Datacite
  # Datacite Client
  class Client
    def initialize(url:, request_klass:, attributes:)
      @datacite_url = url
      @request_klass = request_klass
      @body = metadata(attributes).to_json
    end

    def make_request
      response = http.request(request)
      Datacite::DOIResponse.new(JSON.parse(response.read_body, symbolize_names: true))
    end

    def self.mint(attributes = nil)
      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois"),
        request_klass: Net::HTTP::Post,
        attributes: attributes
      )

      client.make_request
    end

    def self.modify(doi, attributes)
      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois/#{doi}"),
        request_klass: Net::HTTP::Put,
        attributes: attributes
      )
      client.make_request
    end

    private

    def http
      http = Net::HTTP.new(@datacite_url.host, @datacite_url.port)
      http.use_ssl = true
      http
    end

    def request
      request = @request_klass.new(@datacite_url)
      request['Content-Type'] = 'application/vnd.api+json'
      request.basic_auth(Datacite.config.username, Datacite.config.password)
      request.body = @body
      request
    end

    def metadata(attributes)
      {
        data: {
          attributes: attributes
        }
      }
    end
  end
end
