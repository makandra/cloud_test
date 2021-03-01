
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cloud_test/version"

Gem::Specification.new do |spec|
  spec.name          = "cloud_test"
  spec.version       = CloudTest::VERSION
  spec.authors       = ["Philipp Häusele"]
  spec.email         = ["philipp.haeusele@makandra.de"]

  spec.summary       = %q{Enables automated Cloud-Testing with various providers. }
  spec.description   = %q{Enables cross-browser-testing with by the integration of the following providers Browserstack, Crossbrowsertesting, Saucelabs and lambdatest. Based on cucumber and capybara}
  spec.homepage      = "https://github.com/makandra/cloud_test"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "RubyGems.org"

    spec.metadata["homepage_uri"] = "https://github.com/makandra/cloud_test"
    spec.metadata["source_code_uri"] = "https://github.com/makandra/cloud_test"
    spec.metadata["changelog_uri"] = "https://github.com/makandra/cloud_test/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "aruba"

  spec.add_dependency "thor"
  spec.add_dependency 'capybara'
  spec.add_dependency "cucumber"
  spec.add_development_dependency "selenium-webdriver"
end
