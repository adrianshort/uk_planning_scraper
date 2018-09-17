require "uk_planning_scraper/version"
require 'uk_planning_scraper/idox'
require 'uk_planning_scraper/northgate'
require 'logger'

module UKPlanningScraper
  def self.search(search_url, params, options = {})
    default_options = {
      delay: 10,
    }
    options = default_options.merge(options) # The user-supplied options override the defaults
    
    # Select which scraper to use based on the URL
    if search_url.match(/search\.do\?action=advanced/i)
      return self.scrape_idox(search_url, params, options)
    elsif search_url.match(/generalsearch\.aspx/i)
      return self.scrape_northgate(search_url, params, options)
    else
      # Not supported
      raise "Planning system not supported for URL: #{search_url}"
    end
  end
end
