# frozen_string_literal: true

require_relative 'lib/datacite/version'

Gem::Specification.new do |spec|
  spec.name          = 'datacite-client'
  spec.version       = Datacite::VERSION
  spec.authors       = ['Tricia Jenkins']
  spec.email         = ['tricia.g.jenkins@gmail.com']
  spec.homepage = 'https://github.com/ualbertalib/datacite-client'

  spec.summary       = 'Ruby client for Datacite API Version 2'
  spec.description   = 'Ruby client for Datacite API Version 2 (https://support.datacite.org/reference/dois-2)'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['source_code_uri'] = 'https://github.com/ualbertalib/datacite-client'
  spec.metadata['changelog_uri'] = 'https://github.com/ualbertalib/datacite-client/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_development_dependency 'activesupport', '>= 6.1.4.1', '~> 7.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.17.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.12'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'vcr', '5.0'
  spec.add_development_dependency 'webmock', '~> 3.14'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
