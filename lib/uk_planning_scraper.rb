require "uk_planning_scraper/version"
require 'mechanize'
require 'time'
require 'logger'
require 'pp'

module UKPlanningScraper
  def self.search(search_url, criteria, options = {})
    default_options = {
      delay: 10,
    }
    @options = default_options.merge(options) # The user-supplied options override the defaults

    @search_url = search_url
    @base_url = search_url.match(/(https?:\/\/.+?)\//)[1]
    
    apps = []
    # Regex doesn't work for Newham, Greenwich, Tower Hamlets which don't have the Received date in the text
    meta_regex = /Ref\. No:\s+(.+)\s+.+\s+Received:\s+(.+)\s+.+\s+Validated:\s+(.+)\s+.+\s+Status:\s+(.+)/

    agent = Mechanize.new
    puts "Getting: #{@search_url}"
    page = agent.get(@search_url) # load the search form page

    
    # Fill out and submit search form
    form = page.form('searchCriteriaForm')
    # form.action = form.action + '&searchCriteria.resultsPerPage=100'

    # Some councils don't have the received from/to dates on their form, eg Newham
    form.send(:"date(applicationReceivedStart)", criteria[:received_from].strftime("%d/%m/%Y")) if criteria[:received_from]
    form.send(:"date(applicationReceivedEnd)", criteria[:received_to].strftime("%d/%m/%Y")) if criteria[:received_to]

    form.send(:"date(applicationValidatedStart)", criteria[:validated_from].strftime("%d/%m/%Y")) if criteria[:validated_from]
    form.send(:"date(applicationValidatedEnd)", criteria[:validated_to].strftime("%d/%m/%Y")) if criteria[:validated_to]

    form.send(:"searchCriteria\.description", criteria[:description])
    
    # Some councils don't have the applicant name on their form, eg Bexley
    form.send(:"searchCriteria\.applicantName", criteria[:applicant_name]) if form.has_field? 'searchCriteria.applicantName'
    form.send(:"searchCriteria\.caseType", criteria[:application_type])
    page = form.submit

    loop do
      # Parse search results
      items = page.search('li.searchresult')

      puts "Found #{items.size} apps on this page."

      items.each do |app|
        matches = app.at("p.metaInfo").inner_html.match(meta_regex)
        
        data = {
          council_reference: matches[1].strip,
          scraped_at: Time.now,
          date_received: Date.parse(matches[2]),
          date_validated: Date.parse(matches[3]),
          info_url: @base_url + app.at('a')['href'],
          address: app.at('p.address').inner_text.strip,
          description: app.at('a').inner_text.strip,
          status: matches[4].strip
        }
        
        apps << data
      end

      # Get the Next button from the pager, if there is one
      if next_button = page.at('a.next')
        next_url = @base_url + next_button[:href]# + '&searchCriteria.resultsPerPage=100'
        sleep @options[:delay]
        puts "Getting: #{next_url}"
        page = agent.get(next_url)
      else
        break
      end
    end
    apps
  end
end
