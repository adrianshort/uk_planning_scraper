require 'date'

module UKPlanningScraper
  class Authority
    # Parameter methods for Authority#scrape
    # Desgined to be method chained, eg:
    # 
    # applications = UKPlanningScraper::Authority.named("Barnet"). \
    # development_type("Q22").keywords("illuminat"). \
    # validated_days(30).scrape

    def validated_days(n)
      # Validated within the last n days
      # Assumes that every scraper/system can do a date range search
      check_class(n, Fixnum)

      unless n > 0
        raise ArgumentError.new("validated_days must be greater than 0")
      end
      
      validated_from(Date.today - (n - 1))
      validated_to(Date.today)
      self
    end

    def received_days(n)
      # received within the last n days
      # Assumes that every scraper/system can do a date range search
      check_class(n, Fixnum)

      unless n > 0
        raise ArgumentError.new("received_days must be greater than 0")
      end
      
      received_from(Date.today - (n - 1))
      received_to(Date.today)
      self
    end

    def decided_days(n)
      # decided within the last n days
      # Assumes that every scraper/system can do a date range search
      check_class(n, Fixnum)

      unless n > 0
        raise ArgumentError.new("decided_days must be greater than 0")
      end
      
      decided_from(Date.today - (n - 1))
      decided_to(Date.today)
      self
    end
    
    def applicant_name(s)
      unless system == 'idox'
        raise NoMethodError.new("applicant_name is only implemented for Idox. \
          This authority (#{@name}) is #{system.capitalize}.")
      end
      
      check_class(s, String)
      @scrape_params[:applicant_name] = s.strip
      self
    end

    def case_officer_code(s)
      unless system == 'northgate'
        raise NoMethodError.new("case_officer_code is only implemented for Northgate. \
          This authority (#{@name}) is #{system.capitalize}.")
      end
      
      check_class(s, String)
      @scrape_params[:case_officer_code] = s.strip
      self
    end

    def application_type(s)
      unless system == 'idox'
        raise NoMethodError.new("application_type is only implemented for \
          Idox. This authority (#{@name}) is #{system.capitalize}.")
      end
      
      check_class(s, String)
      @scrape_params[:application_type] = s.strip
      self
    end

    def development_type(s)
      unless system == 'idox'
        raise NoMethodError.new("development_type is only implemented for \
          Idox. This authority (#{@name}) is #{system.capitalize}.")
      end
      
      check_class(s, String)
      @scrape_params[:development_type] = s.strip
      self
    end

    def status(s)
      check_class(s, String)
      @scrape_params[:status] = s.strip
      self
    end

    private
    
    # Handle the simple params with this
    def method_missing(method_name, *args)
      sc_params = {
        validated_from: Date,
        validated_to: Date,
        received_from: Date,
        received_to: Date,
        decided_from: Date,
        decided_to: Date,
        keywords: String
      }
      
      value = args[0]
      
      if sc_params[method_name]
        check_class(value, sc_params[method_name], method_name.to_s)
        value.strip! if value.class == String
        
        if value.class == Date && value > Date.today
          raise ArgumentError.new("#{method_name} can't be a date in the " + \
            "future (#{value.to_s})")
        end
        
        @scrape_params[method_name] = value
        self
      else
        raise NoMethodError.new(method_name.to_s)
      end
    end

    def clear_scrape_params
      @scrape_params = {}
    end
    
    # https://stackoverflow.com/questions/5100299/how-to-get-the-name-of-the-calling-method
    def check_class(
      param_value,
      expected_class,
      param_name = caller_locations(1, 1)[0].label) # name of calling method
      unless param_value.class == expected_class
        raise TypeError.new("#{param_name} must be a " \
          "#{expected_class} not a #{param_value.class.to_s}")
      end
    end
  end
end
