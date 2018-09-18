require "uk_planning_scraper/version"
require "uk_planning_scraper/authority"
require 'uk_planning_scraper/idox'
require 'uk_planning_scraper/northgate'
require 'logger'

module UKPlanningScraper
  class SystemNotSupportedError < StandardError
  end
end
