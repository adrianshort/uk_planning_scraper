# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "uk_planning_scraper/version"

Gem::Specification.new do |spec|
  spec.name          = "uk_planning_scraper"
  spec.version       = UKPlanningScraper::VERSION
  spec.authors       = ["Adrian Short"]
  spec.email         = 'adrian@adrianshort.org'
  spec.summary       = %q{Scrape planning applications data from UK council websites.}
  spec.homepage      = "https://github.com/adrianshort/uk_planning_scraper/"
  
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/adrianshort/uk_planning_scraper/blob/master/CHANGELOG.md"

  spec.licenses      = ['LGPL-3.0']

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.5"
  spec.add_development_dependency "pry", "~> 0.11"

  spec.add_runtime_dependency "mechanize", "~> 2.7"
  spec.add_runtime_dependency "http", "~> 3.3"
end
