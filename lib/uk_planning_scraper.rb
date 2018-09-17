require "uk_planning_scraper/version"
require 'uk_planning_scraper/idox'
require 'mechanize'
require 'time'
require 'logger'
require 'pp'

module UKPlanningScraper
  def self.search(search_url, params, options = {})
    default_options = {
      delay: 10,
    }
    options = default_options.merge(options) # The user-supplied options override the defaults
    
    # Select which scraper to use based on the URL
    if search_url.match(/search.do\?action=advanced/i)
      # Idox
      return self.scrape_idox(search_url, params, options)
    else
      # Not supported
      raise "Planning system not supported for URL: #{search_url}"
    end
  end
end
