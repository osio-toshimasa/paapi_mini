# frozen_string_literal: true

require_relative "lib/paapi_mini/version"

Gem::Specification.new do |spec|
  spec.name = "paapi_mini"
  spec.version = PaapiMini::VERSION
  spec.authors = ["tossi-punch"]
  spec.email = ["osio.toshimasa@gmail.com"]

  spec.summary = "Amazon SearchItems By Amazon Advertising Product API."
  spec.description = "paapi_mini is PA-API5.0 client. This Gem is implemented using only the Ruby standard library, so it does not depend on other Gems. supported by searchItems api only."
  spec.homepage = "https://github.com/osio-toshimasa/paapi_mini"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/osio-toshimasa/paapi_mini"
  spec.metadata["changelog_uri"] = "https://github.com/osio-toshimasa/paapi_mini/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
