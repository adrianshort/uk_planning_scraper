module UKPlanningScraper
  class Application
    # Short authority name, eg Camden.
    attr_accessor :authority_name
    
    # The authority's own reference number for this application.
    attr_accessor :council_reference
    
    # Date the application was received by the authority.
    attr_accessor :date_received
    
    # Date the application was declared valid by the authority.
    attr_accessor :date_validated
    
    # The authority's own description of the application's current status.
    # There is no nationally-mandated scheme for these values, so they vary
    # according to local custom.
    attr_accessor :status

    # The datetime at which the application data was scraped from the
    # authority's website.
    attr_accessor :scraped_at
    
    # The URL of the main details page for this application.
    attr_accessor :info_url
    
    # The site address for the application.
    attr_accessor :address
    
    # The applicant's own description of the proposal.
    attr_accessor :description
    
    # The number of documents associated with this application.
    # According to local custom, this may include representations by official
    # consultees and the public.
    # Take care when using this as a proxy for the complexity of the application
    # or the scale of the public response to it.
    attr_accessor :documents_count
    
    # The URL on the authority's website where the application's documents are.
    attr_accessor :documents_url
    
    # Used or not according to local custom. Some authorities use it for the
    # Planning Portal reference number for the application.
    attr_accessor :alternative_reference
    
    # The authority's own description of the decision when made.
    # There is no nationally-mandated standard for these codes and custom or
    # consistency may vary even within an authority.
    attr_accessor :decision
    
    # The date the authority made the decision.
    # This is a reliable proxy for which applications have been decided.
    attr_accessor :date_decision
    
    # 
    attr_accessor :appeal_status
    
    attr_accessor :appeal_decision

    # Final day of the statutory notification/consultation period for this
    # application.
    # If there is more than one notification then this will be used
    # according to local custom
    attr_accessor :consultation_end_date
    
    # Final day of the statutory determination period for this application.
    # If the authority and applicant agree an extension of time this may be
    # changed according to local custom.
    attr_accessor :statutory_due_date
    
    # Final day of an agreed extension of the determination period for this
    # application.
    # This may change if there are subsequent extensions.
    attr_accessor :extended_expiry_date

    # Application type: Full planning permission, advertisement,
    # LDC, prior approval etc.
    # Codes are specific to each local planning authority although there will
    # be a high degree of overlap between LPAs
    attr_accessor :application_type

    attr_accessor :location_easting
    attr_accessor :location_northing


    def to_hash
      {
        scraped_at: @scraped_at,
        authority_name: @authority_name,
        council_reference: @council_reference,
        date_received: @date_received,
        date_validated: @date_validated,
        status: @status,
        decision: @decision,
        date_decision: @date_decision,
        info_url: @info_url,
        address: @address,
        description: @description,
        documents_count: @documents_count,
        documents_url: @documents_url,
        alternative_reference: @alternative_reference,
        appeal_status: @appeal_status,
        appeal_decision: @appeal_decision,
        consultation_end_date: @consultation_end_date,
        statutory_due_date: @statutory_due_date,
        extended_expiry_date: @extended_expiry_date,
        application_type: @application_type,
        location_easting: @location_easting,
        location_northing: @location_northing
      }
    end
    
    def valid?
      return true if @authority_name && @council_reference && @info_url
      false
    end
  end
end
