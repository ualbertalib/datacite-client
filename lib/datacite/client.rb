# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

module Datacite
  #
  # Datacite Client
  #
  # +attributes+ are expected in the following format
  #
  #   {
  #     "doi": "10.5438/0012",
  #     "creators": [{
  #       "name": "DataCite Metadata Working Group"
  #      }],
  #     "titles": [{
  #       "title": "DataCite Metadata Schema Documentation for the Publication and Citation of Research Data v4.0"
  #     }],
  #     "publisher": "DataCite e.V.",
  #     "publicationYear": 2016,
  #     "types": {
  #       "resourceTypeGeneral": "Text"
  #     }
  #   }
  # see https://support.datacite.org/reference/dois-2#put_dois-id for more information on specific attributes and
  # https://schema.datacite.org/json/kernel-4.3/datacite_4.3_schema.json for validation.
  class Client
    #
    # Create an instance of our client
    #
    # The +url+ is the target for the request.  The +request_klass+ is either <tt>Net::HTTP::Post</tt> or
    # <tt>Net::HTTP::Put</tt> and the +attributes+ are described above
    #
    def initialize(url:, request_klass:, attributes:)
      @datacite_url = url
      @request_klass = request_klass
      @body = metadata(attributes).to_json
    end

    #
    # Mints a new DOI and returns the <tt>Datacite::DOIResponse</tt> or raises an <tt>Datacite::Error</tt>
    #
    # ==== Examples
    #   Datacite::Client.mint # will create a draft doi
    #   Datacite::Client.mint(attributes) # will reserve a new identifier and publish the metadata
    def self.mint(attributes = {})
      attributes[:event] = Datacite::Event::PUBLISH unless attributes.empty?
      attributes[:prefix] = Datacite.config.prefix

      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois"),
        request_klass: Net::HTTP::Post,
        attributes:
      )

      client.make_request
    end

    #
    # Modifies a DOI and returns the <tt>Datacite::DOIResponse</tt> or raises an <tt>Datacite::Error</tt>
    #
    # Given the +doi+ of the object you wish to modify, a hash of the +attributes+ that describe the object,
    # and optionally an +event+ which is one of <tt>Datacite::Event::PUBLISH</tt>, <tt>Datacite::Event::REGISTER</tt>,
    # or <tt>Datacite::Event::HIDE</tt>.
    # Use +reason+ to justify the event transition.
    #
    # ==== Examples
    #   Datacite::Client.modify("10.5438/0012", attributes)
    #   Datacite::Client.modify("10.5438/0012", { reason: 'unavailable | withdrawn', event: Datacite::Event::HIDE })
    #   # will change the status of the doi to hidden
    #   Datacite::Client.modify("10.5438/0012", attributes, event: Datacite::Event::PUBLISH)
    #   # will modify the attributes and change the doi to findable
    #
    def self.modify(doi, attributes, event: nil, reason: nil)
      attributes[:event] = event unless event.nil?
      attributes[:reason] = reason unless reason.nil?
      client = Client.new(
        url: URI("https://#{Datacite.config.host}/dois/#{doi}"),
        request_klass: Net::HTTP::Put,
        attributes:
      )
      client.make_request
    end

    #
    # Make a request to the Datacite API and return a <tt>Datacite::DOIResponse</tt>, the response of the request.
    #
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
          attributes:
        }
      }
    end

    def error_description(response_body)
      JSON.parse(response_body, symbolize_names: true)[:errors].map { |error| error[:title] }.join(', ')
    end
  end
end
