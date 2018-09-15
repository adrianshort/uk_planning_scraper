require "uk_planning_scraper/version"
require 'mechanize'
require 'time'
require 'logger'
require 'pp'

module UKPlanningScraper
  def self.search(search_url, params, options = {})
    default_options = {
      delay: 10,
    }
    @options = default_options.merge(options) # The user-supplied options override the defaults

    @search_url = search_url
    @base_url = search_url.match(/(https?:\/\/.+?)\//)[1]
    
    apps = []

    agent = Mechanize.new
    puts "Getting: #{@search_url}"
    page = agent.get(@search_url) # load the search form page

    
    # Fill out and submit search form
    form = page.form('searchCriteriaForm')
    # form.action = form.action + '&searchCriteria.resultsPerPage=100'

    # Some councils don't have the received from/to dates on their form, eg Newham
    form.send(:"date(applicationReceivedStart)", params[:received_from].strftime("%d/%m/%Y")) if params[:received_from]
    form.send(:"date(applicationReceivedEnd)", params[:received_to].strftime("%d/%m/%Y")) if params[:received_to]

    form.send(:"date(applicationValidatedStart)", params[:validated_from].strftime("%d/%m/%Y")) if params[:validated_from]
    form.send(:"date(applicationValidatedEnd)", params[:validated_to].strftime("%d/%m/%Y")) if params[:validated_to]

    form.send(:"searchCriteria\.description", params[:description])
    
    # Some councils don't have the applicant name on their form, eg Bexley
    form.send(:"searchCriteria\.applicantName", params[:applicant_name]) if form.has_field? 'searchCriteria.applicantName'
    form.send(:"searchCriteria\.caseType", params[:application_type])
    page = form.submit

    loop do
      # Parse search results
      items = page.search('li.searchresult')

      puts "Found #{items.size} apps on this page."

      items.each do |app|
        data = {}

        # Parse info line
        info_line = app.at("p.metaInfo").inner_text.strip
        bits = info_line.split('|').map { |e| e.strip.delete("\r\n") }
        
        bits.each do |bit|
          if matches = bit.match(/Ref\. No:\s+(.+)/)
            data[:council_reference] = matches[1]
          end

          if matches = bit.match(/(Received|Registered):\s+(.+)/)
            data[:date_received] = Date.parse(matches[2])
          end
          
          if matches = bit.match(/Validated:\s+(.+)/)
            data[:date_validated] = Date.parse(matches[1])
          end

          if matches = bit.match(/Status:\s+(.+)/)
            data[:status] = matches[1]
          end
        end

        data.merge!({
          scraped_at: Time.now,
          info_url: @base_url + app.at('a')['href'],
          address: app.at('p.address').inner_text.strip,
          description: app.at('a').inner_text.strip,
        })
        
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
