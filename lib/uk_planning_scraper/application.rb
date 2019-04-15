module UKPlanningScraper
  class Application
    attr_accessor :authority_name
    attr_accessor :council_reference
    attr_accessor :date_received
    attr_accessor :date_validated
    attr_accessor :status
    attr_accessor :scraped_at
    attr_accessor :info_url
    attr_accessor :address
    attr_accessor :description
    attr_accessor :documents_count
    attr_accessor :documents_url
    attr_accessor :alternative_reference
    attr_accessor :decision
    attr_accessor :date_decision
    attr_accessor :appeal_status
    attr_accessor :appeal_decision

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
        appeal_decision: @appeal_decision
      }
    end

    def valid?
      return true if @authority_name && @council_reference && @info_url
      false
    end
  end
end
