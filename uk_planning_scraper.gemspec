# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "uk_planning_scraper/version"

Gem::Specification.new do |spec|
  spec.name          = "uk_planning_scraper"
  spec.version       = UKPlanningScraper::VERSION
  spec.authors       = ["Adrian Short"]

  spec.summary       = %q{Get planning applications data from UK council websites.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/adrianshort/uk_planning_scraper/"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.8.0"
  spec.add_development_dependency "simplecov", "~> 0.16.1"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency "mechanize", "~> 2.7"
  spec.add_runtime_dependency "http"
end
