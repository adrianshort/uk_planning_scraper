require 'simplecov'
SimpleCov.start

require 'uk_planning_scraper'
require 'webmock'
require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.allow_http_connections_when_no_cassette = true
end
