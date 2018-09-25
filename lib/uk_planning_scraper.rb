require "uk_planning_scraper/version"
require "uk_planning_scraper/authority"
require 'uk_planning_scraper/idox'
require 'uk_planning_scraper/northgate'
require 'logger'

module UKPlanningScraper
  class SystemNotSupported < StandardError; end
  class AuthorityNotFound < StandardError; end
  class TooManySearchResults < StandardError; end
end
