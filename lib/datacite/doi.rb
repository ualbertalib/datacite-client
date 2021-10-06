require 'uri'
require 'net/http'
require 'openssl'

EMPTY_METADATA_HASH =
  {
    data: {
      attributes: {}
    }
  }

class Datacite::DOI
  def initialize(metadata)
    metadata[:data][:attributes].each do |(k, v)|
      self.class.attr_accessor(k) unless self.class.method_defined? k.to_sym
      send("#{k}=", v)
    end
  end

  def self.mint(metadata = nil)
    url = URI("https://#{Datacite.config.host}/dois")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/vnd.api+json'
    request.basic_auth(Datacite.config.username, Datacite.config.password)

    if metadata.nil?
      metadata = EMPTY_METADATA_HASH
    else
      metadata[:data][:attributes][:event] = 'publish'
    end
    metadata[:data][:attributes][:prefix] = Datacite.config.prefix

    request.body = metadata.to_json
    response = http.request(request)
    Datacite::DOI.new(JSON.parse(response.read_body, symbolize_names: true))
  end

  def self.modify(doi, metadata)
    url = URI("https://#{Datacite.config.host}/dois/#{doi}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(url)
    request['Content-Type'] = 'application/vnd.api+json'
    request.basic_auth(Datacite.config.username, Datacite.config.password)
    request.body = metadata.to_json
    response = http.request(request)
    Datacite::DOI.new(JSON.parse(response.read_body, symbolize_names: true))
  end
end
