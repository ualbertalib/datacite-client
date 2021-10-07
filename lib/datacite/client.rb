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
    def initialize(url:, request_klass:, body:)
      @datacite_url = url
      @request_klass = request_klass
      @body = body
    end

    def make_request
      response = http.request(request)
      Datacite::DOIResponse.new(JSON.parse(response.read_body, symbolize_names: true))
    end

    def self.mint(metadata = nil)
      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois"),
        request_klass: Net::HTTP::Post,
        body: metadata.to_json
      )

      client.make_request
    end

    def self.modify(doi, metadata)
      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois/#{doi}"),
        request_klass: Net::HTTP::Put,
        body: metadata.to_json
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
  end
end
