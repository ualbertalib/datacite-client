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
  spec.required_ruby_version = '>= 2.6.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

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

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr', '5.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
