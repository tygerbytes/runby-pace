module RunbyPace

  class PaceUnits

    def self.description(units)
      descriptions[units]
    end

    def self.distance_conversion_factor(units)
      self.distance_conversion_factors[units]
    end

    private

    def self.descriptions
      { :km => 'Kilometers', :mi => 'Miles' }
    end

    def self.distance_conversion_factors
      { :km => 1.0, :mi => 1.612903225806452 }
    end

  end
end
