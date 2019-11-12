module UKPlanningScraper
  class Property
    attr_accessor :uprn
    attr_accessor :address
    attr_accessor :number
    attr_accessor :street
    attr_accessor :town
    attr_accessor :postcode
    attr_accessor :ward
    attr_accessor :parish

    def to_hash
      {
        uprn: @uprn,
        address: @address,
        number: @number,
        street: @street,
        town: @town,
        postcode: @postcode,
        ward: @ward,
        parish: @parish
      }
    end

    def valid?
      return true if @uprn
      false
    end
  end
end
