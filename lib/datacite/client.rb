# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

module Datacite
  # Datacite Client
  class Client
    def initialize(url:, request_klass:, attributes:)
      @datacite_url = url
      @request_klass = request_klass
      @body = metadata(attributes).to_json
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def make_request
      response = http.request(request)
      case response
      when Net::HTTPOK, Net::HTTPCreated
        Datacite::DOIResponse.new(JSON.parse(response.read_body, symbolize_names: true))
      when Net::HTTPUnprocessableEntity
        raise Datacite::UnprocessableError, error_description(response.read_body)
      when Net::HTTPNotFound
        raise Datacite::NotFoundError, error_description(response.read_body)
      when Net::HTTPUnauthorized
        raise Datacite::UnauthorizedError, error_description(response.read_body)
      else
        raise Datacite::Error, error_description(response.read_body)
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def self.mint(attributes = {})
      attributes[:event] = Datacite::Event::PUBLISH unless attributes.empty?
      attributes[:prefix] = Datacite.config.prefix

      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois"),
        request_klass: Net::HTTP::Post,
        attributes: attributes
      )

      client.make_request
    end

    def self.modify(doi, attributes, event: nil, reason: nil)
      attributes[:event] = event unless event.nil?
      attributes[:reason] = reason unless reason.nil?
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

    def metadata(attributes = {})
      {
        data: {
          attributes: attributes
        }
      }
    end

    def error_description(response_body)
      JSON.parse(response_body, symbolize_names: true)[:errors].map { |error| error[:title] }.join(', ')
    end
  end
end
