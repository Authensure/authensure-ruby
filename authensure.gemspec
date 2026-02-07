# frozen_string_literal: true

require_relative "lib/authensure/version"

Gem::Specification.new do |spec|
  spec.name = "authensure"
  spec.version = Authensure::VERSION
  spec.authors = ["Authensure"]
  spec.email = ["support@authensure.app"]

  spec.summary = "Official Authensure SDK for Ruby"
  spec.description = "Ruby SDK for Authensure - the electronic signature and document authentication platform. " \
                     "Provides a simple interface to create envelopes, manage documents, handle signatures, " \
                     "and integrate webhooks."
  spec.homepage = "https://authensure.app"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Authensure/authensure-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/Authensure/authensure-ruby/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://authensure.app/docs/sdk/ruby"
  spec.metadata["bug_tracker_uri"] = "https://github.com/Authensure/authensure-ruby/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.0", "< 3.0"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "faraday-retry", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.0"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
end
