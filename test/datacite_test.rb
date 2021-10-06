require 'test_helper'

class DataciteTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Datacite::VERSION
  end

  METADATA = {
    data: {
      attributes: {
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
      }
    }
  }.freeze

  def test_that_doi_is_created_from_metadata
    doi = Datacite::DOI.new(METADATA)
    assert_equal [{ name: 'Jose Jacobson' }], doi.creators
    assert_equal [{ title: 'Clouds of Witness' }], doi.titles
    assert_equal [{ description: 'Fugit qui repellendus dolorem.' }], doi.descriptions
    assert_equal 'Shoemaker & Hoard Publishers', doi.publisher
    assert_equal '2021', doi.publicationYear
    assert_equal 'Text/Book', doi.types[:resourceType]
    assert_equal 'Text', doi.types[:resourceTypeGeneral]
    assert_equal 'https://example.com/', doi.url
    assert_equal 'http://datacite.org/schema/kernel-4', doi.schemaVersion
  end

  def test_minting_a_doi
    VCR.use_cassette('datacite_minting') do
      assert_equal '10.80243/h6bm-2w80', Datacite::DOI.mint.doi
    end
  end

  def test_minting_a_doi_with_metadata
    VCR.use_cassette('datacite_minting_with_metadata') do
      assert_equal '10.80243/p8wq-ps50', Datacite::DOI.mint(METADATA).doi
    end
  end

  def test_updating_a_doi
    metadata = METADATA.deep_dup
    # assigment directly to the key changes the hash for other tests
    metadata[:data][:attributes][:creators] = [{ name: 'Judy Gutkowski' }, { name: 'Jose Jacobson' }]
    VCR.use_cassette('datacite_modify') do
      assert_equal [{ name: 'Judy Gutkowski', affiliation: [], nameIdentifiers: [] }, { name: 'Jose Jacobson', affiliation: [], nameIdentifiers: [] }],
                   Datacite::DOI.modify('10.80243/p8wq-ps50', metadata).creators
    end
  end
end
