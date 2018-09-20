require 'mechanize'
require 'pp'

module UKPlanningScraper
  def self.scrape_idox(search_url, params, options)
    puts "Using Idox scraper."
    base_url = search_url.match(/(https?:\/\/.+?)\//)[1]
    
    apps = []

    agent = Mechanize.new
    puts "Getting: #{search_url}"
    page = agent.get(search_url) # load the search form page

    # Check that the search form is actually present.
    # When Idox has an internal error it returns an error page with HTTP 200.
    unless form = page.form('searchCriteriaForm')
      puts "Error: Search form page failed to load due to Idox internal error."
      return []
    end
    # form.action = form.action + '&searchCriteria.resultsPerPage=100'

    # Fill out and submit search form

    # Some councils don't have the received from/to dates on their form, eg Newham
    form.send(:"date(applicationReceivedStart)", params[:received_from].strftime("%d/%m/%Y")) if params[:received_from]
    form.send(:"date(applicationReceivedEnd)", params[:received_to].strftime("%d/%m/%Y")) if params[:received_to]

    form.send(:"date(applicationValidatedStart)", params[:validated_from].strftime("%d/%m/%Y")) if params[:validated_from]
    form.send(:"date(applicationValidatedEnd)", params[:validated_to].strftime("%d/%m/%Y")) if params[:validated_to]

    form.send(:"date(applicationDecisionStart)", params[:decided_from].strftime("%d/%m/%Y")) if params[:decided_from]
    form.send(:"date(applicationDecisionEnd)", params[:decided_to].strftime("%d/%m/%Y")) if params[:decided_to]

    form.send(:"searchCriteria\.description", params[:keywords])
    
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
          info_url: base_url + app.at('a')['href'],
          address: app.at('p.address').inner_text.strip,
          description: app.at('a').inner_text.strip,
        })
        
        apps << data
      end

      # Get the Next button from the pager, if there is one
      if next_button = page.at('a.next')
        next_url = base_url + next_button[:href]# + '&searchCriteria.resultsPerPage=100'
        sleep options[:delay]
        puts "Getting: #{next_url}"
        page = agent.get(next_url)
      else
        break
      end
    end
    
    # Scrape the summary tab for each app
    apps.each_with_index do |app, i|
      sleep options[:delay]
      puts "#{i + 1} of #{apps.size}: #{app[:info_url]}"
      res = agent.get(app[:info_url])
      
      if res.code == '200' # That's a String not an Integer, ffs
        # Parse the summary tab for this app

        app[:scraped_at] = Time.now

        # The Documents tab doesn't show if there are no documents (we get li.nodocuments instead)
        # Bradford has #tab_documents but without the document count on it
        app[:documents_count] = 0
        app[:documents_url] = nil

        if documents_link = res.at('.associateddocument a')
          if documents_link.inner_text.match(/\d+/)
            app[:documents_count] = documents_link.inner_text.match(/\d+/)[0].to_i
            app[:documents_url] = base_url + documents_link[:href]
          end
        elsif documents_link = res.at('#tab_documents')
          if documents_link.inner_text.match(/\d+/)
            app[:documents_count] = documents_link.inner_text.match(/\d+/)[0].to_i
            app[:documents_url] = base_url + documents_link[:href]
          end
        end
        
        # We need to find values in the table by using the th labels.
        # The row indexes/positions change from site to site (or even app to app) so we can't rely on that.

        res.search('#simpleDetailsTable tr').each do |row|
          key = row.at('th').inner_text.strip
          value = row.at('td').inner_text.strip
          
          case key
            when 'Reference'
              app[:council_reference] = value
            when 'Alternative Reference'
              app[:alternative_reference] = value
            when 'Planning Portal Reference'
              app[:alternative_reference] = value
            when 'Application Received'
              app[:date_received] = Date.parse(value) if value.match(/\d/)
            when 'Application Registered'
              app[:date_received] = Date.parse(value) if value.match(/\d/)
            when 'Application Validated'
              app[:date_validated] = Date.parse(value) if value.match(/\d/)
            when 'Address'
              app[:address] = value
            when 'Proposal'
              app[:description] = value
            when 'Status'
              app[:status] = value
            when 'Decision'
              app[:decision] = value
            when 'Decision Issued Date'
              app[:date_decision] = Date.parse(value) if value.match(/\d/)
            when 'Appeal Status'
              app[:appeal_status] = value
            when 'Appeal Decision'
              app[:appeal_decision] = value
            else
              puts "Error: key '#{key}' not found"
          end # case
        end # each row
      else
        puts "Error: HTTP #{res.code}"
      end # if
    end # scrape summary tab for apps
    apps
  end # scrape_idox
end
