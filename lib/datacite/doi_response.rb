# frozen_string_literal: true

module Datacite
  # Datacite API v2 Response
  #
  # ==== Examples
  #   doi = Datacite::DOIResponse.new({ data: { attributes: ATTRIBUTES } })
  #   doi.public_methods false
  #   # => [source=, types, language, state, reason, version=, updated, prefix=, suffix, reason=, prefix, url, creators,
  #         titles, descriptions, publisher, publicationYear, schemaVersion, doi, doi=, source, suffix=, identifiers=,
  #         alternateIdentifiers, alternateIdentifiers=, creators=, titles=, publisher=, container=, publicationYear=,
  #         subjects, subjects=, contributors, contributors=, dates, dates=, language=, types=, relatedIdentifiers,
  #         relatedIdentifiers=, container, sizes, sizes=, formats=, rightsList, identifiers, rightsList=,
  #         descriptions=, geoLocations, xml, geoLocations=, fundingReferences, url=, fundingReferences=, xml=,
  #         contentUrl, contentUrl=, metadataVersion, state=, metadataVersion=, schemaVersion=, isActive, isActive=,
  #         landingPage, landingPage=, viewCount, viewCount=, viewsOverTime, formats, viewsOverTime=, downloadCount,
  #         downloadCount=, downloadsOverTime, downloadsOverTime=, referenceCount, referenceCount=, citationCount,
  #         citationCount=, citationsOverTime, citationsOverTime=, partCount, partCount=, partOfCount, partOfCount=,
  #         versionCount, versionCount=, versionOfCount, versionOfCount=, created=, registered, registered=, published,
  #         published=, version, updated=, created]
  # which will either be a <tt>Hash</tt>
  #   doi.creators # => [{:name=>"Jose Jacobson"}]
  # or a <tt>String</tt>
  #   doi.url # => "https://example.com/"
  class DOIResponse
    # create accessors for all the attributes in the json hash repsonse from Datacite
    def initialize(metadata)
      metadata[:data][:attributes].each do |(k, v)|
        self.class.attr_accessor(k) unless self.class.method_defined? k.to_sym
        send(:"#{k}=", v)
      end
    end
  end
end
