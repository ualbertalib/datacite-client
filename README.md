# Datacite

Ruby client for Datacite API Version 2 See https://support.datacite.org/reference/dois-2.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'datacite-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install datacite-client

## Configure

You can configure the following default values by overriding these values using `Datacite.configure` method or setting the appropriate environment variable.
```
host          # ENV['DATACITE_HOST'] or 'api.test.datacite.org' by default
username      # ENV['DATACITE_USERNAME']
password      # ENV['DATACITE_PASSWORD']
prefix        # ENV['DATACITE_PREFIX']
```

## Usage

Attributes is expected in the following format
```
{
  "doi": "10.5438/0012",
  "creators": [{
    "name": "DataCite Metadata Working Group"
   }],
  "titles": [{
    "title": "DataCite Metadata Schema Documentation for the Publication and Citation of Research Data v4.0"
  }],
  "publisher": "DataCite e.V.",
  "publicationYear": 2016,
  "types": {
    "resourceTypeGeneral": "Text"
  }
}
```
see https://support.datacite.org/reference/dois-2#put_dois-id for more information on specific attributes and https://schema.datacite.org/json/kernel-4.3/datacite_4.3_schema.json for validation.

### Mint/Create
`Datacite::Client.mint` will create a draft doi.

`Datacite::Client.mint(attributes)` will reserve a new identifier and publish the metadata.
### Update
`Datacite::Client.modify(doi, attributes)` will update the metadata.

There are three events 'publish' [`Datacite::Event::PUBLISH`], 'register' [`Datacite::Event::REGISTER`], and 'hide' [`Datacite::Event::HIDE`].  You can use `Datacite::Client#modify` by including the event in your `attributes`:
```
event: 'publish'
```
or using the keyword arguments explicitly to update the metadata and trigger the event:
`Datacite::Client.modify(doi, attributes, event: , reason:)` 

Search for `A word on states - publishing to findable` in https://support.datacite.org/docs/api-create-dois for more information about events.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pgwillia/datacite.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
