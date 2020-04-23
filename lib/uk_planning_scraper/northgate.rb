require 'http'
require 'nokogiri'
require 'logger'

module UKPlanningScraper
  class Authority
    private
    def scrape_northgate(params, options)
      puts "Using Northgate scraper."
      base_url = @url.match(/(https?:\/\/.+?)\//)[1]
      
      # Remove 'generalsearch.aspx' from the end and add '/Generic/' - case sensitive?
      generic_url = @url.match(/.+\//)[0] + 'Generic/'
      
      apps = []

      $stdout.sync = true # Flush output buffer after every write so log messages appear immediately.
      logger = Logger.new($stdout)
      logger.level = Logger::DEBUG

      date_regex = /\d{2}-\d{2}-\d{4}/

      form_vars = {
        'csbtnSearch' => 'Search' # required
      }

      # Keywords
      form_vars['txtProposal'] = params[:keywords]

      # Date received from and to
      if params[:received_from] || params[:received_to]
        form_vars['cboSelectDateValue'] = 'DATE_RECEIVED'
        form_vars['rbGroup'] = 'rbRange'
        form_vars['dateStart'] = params[:received_from].to_s if params[:received_from] # YYYY-MM-DD
        form_vars['dateEnd'] = params[:received_to].to_s if params[:received_to] # YYYY-MM-DD
      end

      # Date validated from and to
      if params[:validated_from] || params[:validated_to]
        form_vars['cboSelectDateValue'] = 'DATE_VALID'
        form_vars['rbGroup'] = 'rbRange'
        form_vars['dateStart'] = params[:validated_from].to_s if params[:validated_from] # YYYY-MM-DD
        form_vars['dateEnd'] = params[:validated_to].to_s if params[:validated_to] # YYYY-MM-DD
      end

      # Date decided from and to
      if params[:decided_from] || params[:decided_to]
        form_vars['cboSelectDateValue'] = 'DATE_DECISION'
        form_vars['rbGroup'] = 'rbRange'
        form_vars['dateStart'] = params[:decided_from].to_s if params[:decided_from] # YYYY-MM-DD
        form_vars['dateEnd'] = params[:decided_to].to_s if params[:decided_to] # YYYY-MM-DD
      end
      
      # Status
      if params[:status]
        form_vars['cboStatusCode'] = params[:status]
      end

      # Case officer code
      if params[:case_officer_code]
        form_vars['cboCaseOfficerCode'] = params[:case_officer_code]
        @url.sub!('GeneralSearch.aspx', 'CaseOfficerWorkloadSearch.aspx')
      end

      logger.info "Form variables: #{form_vars.to_s}"

      headers = {
        'Origin' => base_url,
        'Referer' => @url,
      }

      logger.debug "HTTP request headers:"
      logger.debug(headers.to_s)

      logger.debug "GET: " + @url
      response = HTTP.headers(headers).get(@url)
      logger.debug "Response code: HTTP " + response.code.to_s

      if response.code == 200
        doc = Nokogiri::HTML(response.to_s)
        asp_vars = {
          '__VIEWSTATE' => doc.at('#__VIEWSTATE')['value'],
          '__EVENTVALIDATION' => doc.at('#__EVENTVALIDATION')['value']
         }
      else
        logger.fatal "Bad response from search page. Response code: #{response.code.to_s}."
        raise RuntimeError.new("Northgate: Bad response from search page. Response code: #{response.code.to_s}.")
      end

      cookies = {}
      response.cookies.each { |c| cookies[c.name] = c.value }

      form_vars.merge!(asp_vars)

      logger.debug "POST: " + @url
      response2 = HTTP.headers(headers).cookies(cookies).post(@url, :form => form_vars)
      logger.debug "Response code: HTTP " + response2.code.to_s

      if response2.code == 302
        # Follow the redirect manually
        # Set the page size (PS) to max so we don't have to page through search results
        logger.debug "Location: #{response2.headers['Location']}"
        results_url = URI::encode(base_url + response2.headers['Location'].gsub!('PS=10', 'PS=99999'))
        logger.debug "GET: " + results_url
        response3 = HTTP.headers(headers).cookies(cookies).get(results_url)
        logger.debug "Response code: HTTP " + response3.code.to_s
        doc = Nokogiri::HTML(response3.to_s)
      else
        logger.error "Didn't get redirected from search."
        raise RuntimeError.new("Northgate: didn't get redirected from search.")
      end

      rows = doc.search("table.display_table tr")
      logger.info "Found #{rows.size - 1} applications in search results." # The first row is the header row

      # Iterate over search results
      rows.each do |row|
        if row.at("td") # skip header row which only has th's
          cells = row.search("td")

          app = Application.new
          app.scraped_at = Time.now
          app.council_reference = cells[0].inner_text.strip
          app.info_url = URI::encode(generic_url + cells[0].at('a')[:href].strip)
          app.info_url.gsub!(/%0./, '') # FIXME. Strip junk chars from URL - how can we prevent this?
          app.address = cells[1].inner_text.strip
          app.description = cells[2].inner_text.strip
          app.status = cells[3].inner_text.strip
          raw_date_validated = cells[4].inner_text.strip
          app.date_validated = Date.parse(raw_date_validated) if raw_date_validated != '--'
          app.decision = cells[5].inner_text.strip if cells[5] # Some councils don't have this column, eg Hackney

          apps << app
        end
      end
      apps
    end
  end
end
