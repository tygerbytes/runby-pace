module Runby
  # Represents the distance units (e.g. kilometers, miles) used in paces
  #  including the human-readable description of each unit
  #  and the factor used to convert it to kilometers.
  class PaceUnits
    def self.description(units)
      descriptions[units]
    end

    def self.distance_conversion_factor(units)
      distance_conversion_factors[units]
    end

    ### -- Private class methods --

    private_class_method def self.descriptions
      { km: 'Kilometer', mi: 'Mile' }
    end

    private_class_method def self.distance_conversion_factors
      { km: 1.0, mi: 1.612903225806452 }
    end
  end
end
