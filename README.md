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

Metadata is expected in the following format
```
{
  data: {
    attributes: {}
  }
}
see https://support.datacite.org/reference/dois-2#put_dois-id for more information on specific attributes.
```
### Mint/Create
`Datacite::Client.mint` will create a draft doi.
`Datacite::Client.mint(metadata)` will reserve a new identifier and publish the metadata.
### Update
`Datacite::Client.modify(doi, metadata)` will update the metadata.

There are three events 'publish', 'register', and 'hide'.  You can use `modify` with metadata in the following format to trigger these events.
```
{
  data: {
    attributes: {
        event: 'publish'
    }
  }
}
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/datacite.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
