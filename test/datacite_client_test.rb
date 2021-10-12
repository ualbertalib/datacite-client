# frozen_string_literal: true

require 'test_helper'

class DataciteTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Datacite::VERSION
  end

  ATTRIBUTES = {

    creators: [{ name: 'Jose Jacobson' }],
    titles: [{ title: 'Clouds of Witness' }],
    descriptions: [{ description: 'Fugit qui repellendus dolorem.' }],
    publisher: 'Shoemaker & Hoard Publishers',
    publicationYear: '2021',
    types: {
      resourceType: 'Text/Book',
      resourceTypeGeneral: 'Text'
    },
    url: 'https://example.com/',
    schemaVersion: 'http://datacite.org/schema/kernel-4'
  }.freeze

  # rubocop:disable Metrics/MethodLength
  def test_that_doi_is_created_from_metadata
    doi = Datacite::DOIResponse.new({ data: { attributes: ATTRIBUTES } })
    attributes = {
      creators: doi.creators,
      titles: doi.titles,
      descriptions: doi.descriptions,
      publisher: doi.publisher,
      publicationYear: doi.publicationYear,
      types: {
        resourceType: doi.types[:resourceType],
        resourceTypeGeneral: doi.types[:resourceTypeGeneral]
      },
      url: doi.url,
      schemaVersion: doi.schemaVersion
    }
    assert_equal ATTRIBUTES, attributes
  end
  # rubocop:enable Metrics/MethodLength

  def test_minting_a_doi
    VCR.use_cassette('datacite_minting') do
      assert_equal '10.80243/h6bm-2w80', Datacite::Client.mint.doi
    end
  end

  def test_minting_a_doi_with_metadata
    VCR.use_cassette('datacite_minting_with_metadata') do
      response = Datacite::Client.mint(ATTRIBUTES.deep_dup)
      assert_equal '10.80243/7rpm-3q15', response.doi
    end
  end

  def test_updating_a_doi
    attributes = ATTRIBUTES.deep_dup
    # assigment directly to the key changes the hash for other tests
    attributes[:creators] = [{ name: 'Judy Gutkowski' }, { name: 'Jose Jacobson' }]
    VCR.use_cassette('datacite_modify') do
      response = Datacite::Client.modify('10.80243/p8wq-ps50', attributes)
      assert_equal [
        { name: 'Judy Gutkowski', affiliation: [], nameIdentifiers: [] },
        { name: 'Jose Jacobson', affiliation: [], nameIdentifiers: [] }
      ], response.creators
    end
  end
end
