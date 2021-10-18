# frozen_string_literal: true

require 'test_helper'

class DataciteTest < ActiveSupport::TestCase
  test 'that it has a version number' do
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

  test 'that doi is created from metadata' do
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

  test 'minting a doi' do
    VCR.use_cassette('datacite_minting') do
      response = Datacite::Client.mint
      assert_equal '10.80243/s5m9-cx93', response.doi
      assert_equal Datacite::State::DRAFT, response.state
    end
  end

  test 'minting a doi with metadata' do
    VCR.use_cassette('datacite_minting_with_metadata') do
      response = Datacite::Client.mint(ATTRIBUTES.deep_dup)
      assert_equal '10.80243/7rpm-3q15', response.doi
      assert_equal Datacite::State::FINDABLE, response.state
    end
  end

  test 'updating a doi' do
    attributes = ATTRIBUTES.deep_dup
    # assigment directly to the key changes the hash for other tests
    attributes[:creators] = [{ name: 'Judy Gutkowski' }, { name: 'Jose Jacobson' }]
    VCR.use_cassette('datacite_modify') do
      response = Datacite::Client.modify('10.80243/p8wq-ps50', attributes)
      assert_equal [
        { name: 'Judy Gutkowski', affiliation: [], nameIdentifiers: [] },
        { name: 'Jose Jacobson', affiliation: [], nameIdentifiers: [] }
      ], response.creators
      assert_equal Datacite::State::FINDABLE, response.state
    end
  end

  test 'trigger event on doi' do
    VCR.use_cassette('datacite_trigger_event') do
      response = Datacite::Client.modify('10.80243/p8wq-ps50', {},
                                         event: { event: Datacite::Event::HIDE,
                                                  reason: 'unavailable | not publicly released' })
      assert_equal Datacite::State::REGISTERED, response.state
      assert_equal 'unavailable | not publicly released', response.reason
    end
  end

  test 'NotFound failure' do
    username, password = unset_credentials
    VCR.use_cassette('datacite_notfound_failure') do
      error = assert_raises(Datacite::NotFoundError) { Datacite::Client.mint }
      assert_equal "The resource you are looking for doesn't exist.", error.message
    end
    set_credentials(username, password)
  end

  test 'authentication failure' do
    username, password = unset_password
    VCR.use_cassette('datacite_authentication_failure') do
      error = assert_raises(Datacite::UnauthorizedError) do
        Datacite::Client.modify('10.80243/p8wq-ps50', ATTRIBUTES.deep_dup)
      end
      assert_equal 'Bad credentials.', error.message
    end
    set_credentials(username, password)
  end

  test 'invalid metadata failure' do
    VCR.use_cassette('datacite_invalid_metadata_failure') do
      error = assert_raises(Datacite::UnprocessableError) { Datacite::Client.mint({ one: 'one' }) }
      assert_equal "Can't be blank", error.message
    end
  end

  test 'invalid identifier failure' do
    attributes = ATTRIBUTES.deep_dup
    # assigment directly to the key changes the hash for other tests
    attributes[:creators] = [{ name: 'Judy Gutkowski' }, { name: 'Jose Jacobson' }]

    VCR.use_cassette('datacite_invalid_identifier_failure') do
      error = assert_raises(Datacite::UnprocessableError) { Datacite::Client.modify('doi:10.80243/1234', attributes) }
      assert_equal 'This DOI has already been taken', error.message
    end
  end
end
