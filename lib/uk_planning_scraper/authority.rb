require 'csv'

module UKPlanningScraper
  class Authority
    attr_reader :name, :url
    @@authorities = []

    def initialize(name, url)
      @name = name.strip
      @url = url.strip
      @tags = [] # Strings in arbitrary order
      @applications = [] # Application objects
    end

    def scrape(params, options = {})
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
      
      # Select which scraper to use
      case system
      when 'idox'
        @applications = scrape_idox(params, options)
      when 'northgate'
        @applications = scrape_northgate(params, options)
      else
        raise SystemNotSupported.new("Planning system not supported for #{@name} at URL: #{@url}")
      end
      
      # Post processing
      @applications.each do |app|
        app.authority_name = @name
      end

      # Output as an array of hashes
      output = []
      # FIXME - silently ignores invalid apps. How should we handle them?
      @applications.each { |app| output << app.to_hash if app.valid? }
      output  # Single point of successful exit
    end
    
    def tags
      @tags.sort
    end
    
    # Add multiple tags to existing tags
    def add_tags(tags)
      tags.each { |t| add_tag(t) }
    end
    
    # Add a single tag to existing tags
    def add_tag(tag)
      clean_tag = tag.strip.downcase.gsub(' ', '')
      @tags << clean_tag unless tagged?(clean_tag) # prevent duplicates
    end
    
    def tagged?(tag)
      @tags.include?(tag)
    end
    
    def system
      if @url.match(/search\.do\?action=advanced/i)
        s = 'idox'
      elsif @url.match(/generalsearch\.aspx/i)
        s = 'northgate'
      elsif @url.match(/ocellaweb/i)
        s = 'ocellaweb'
      elsif @url.match(/\/apas\//)
        s = 'agileplanning'
      else
        s = 'unknownsystem'
      end
    end

    def self.all
      @@authorities
    end
    
    # List all the tags in use
    def self.tags
      tags = []
      @@authorities.each { |a| tags << a.tags }
      tags.flatten.uniq.sort
    end
    
    def self.named(name)
      authority = @@authorities.find { |a| name == a.name }
      raise AuthorityNotFound if authority.nil?
      authority 
    end

    # Tagged x
    def self.tagged(tag)
      found = []
      @@authorities.each { |a| found << a if a.tagged?(tag) }
      found
    end

    # Not tagged x
    def self.not_tagged(tag)
      found = []
      @@authorities.each { |a| found << a unless a.tagged?(tag) }
      found
    end

    # Authorities with no tags
    def self.untagged
      found = []
      @@authorities.each { |a| found << a if a.tags.empty? }
      found
    end

    def self.load
      # Don't run this method more than once
      return unless @@authorities.empty?
      CSV.foreach(File.join(File.dirname(__dir__), 'uk_planning_scraper', 'authorities.csv')) do |line|
        auth = Authority.new(line[0], line[1])
        auth.add_tags(line[2..-1])
        auth.add_tag(auth.system)
        @@authorities << auth
      end
    end
  end
end

UKPlanningScraper::Authority.load
