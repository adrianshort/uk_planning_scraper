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
    
    # Validated within the last n days
    # Assumes that every scraper/system can do a date range search
    if params[:validated_days]
      params[:validated_to] = Date.today
      params[:validated_from] = Date.today - (params[:validated_days] - 1)
    end
      
    # Received within the last n days
    # Assumes that every scraper/system can do a date range search
    if params[:received_days]
      params[:received_to] = Date.today
      params[:received_from] = Date.today - (params[:received_days] - 1)
    end
    
    # Decided within the last n days
    # Assumes that every scraper/system can do a date range search
    if params[:decided_days]
      params[:decided_to] = Date.today
      params[:decided_from] = Date.today - (params[:decided_days] - 1)
    end
    
    # Select which scraper to use based on the URL
    if search_url.match(/search\.do\?action=advanced/i)
      apps = self.scrape_idox(search_url, params, options)
    elsif search_url.match(/generalsearch\.aspx/i)
      apps = self.scrape_northgate(search_url, params, options)
    else
      # Not supported
      raise "Planning system not supported for URL: #{search_url}"
    end
    
    apps # Single point of successful exit
  end
end
