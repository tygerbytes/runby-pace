module Runby
  # Represents the distance units (e.g. kilometers, miles) used in paces
  #  including the human-readable description of each unit
  #  and the factor used to convert it to kilometers.
  class PaceUnits
    def self.description(uom)
      @@_distance_uom_definition[uom][:description]
    end

    def self.parse_unit_of_measure(description)
      description = description.strip.chomp
      found_uom = nil
      found_uom_factor = 1
      @@_distance_uom_definition.each do |uom, details|
        if details[:synonyms].include? description
          found_uom = uom
          break
        end
      end
      if found_uom.nil?
        # Search the special UOMs
        @@_distance_uom_definition_special.each_value do |details|
          if details[:synonyms].include? description
            found_uom = details[:uom]
            found_uom_factor = details[:factor]
            break
          end
        end
      end
      { uom: found_uom, factor: found_uom_factor }
    end

    def self.distance_conversion_factor(units)
      distance_conversion_factors[units]
    end

    def self.known_uom?(symbol)
      # TODO: test
      @@_distance_uom_definition.has_key?(symbol) || @@_distance_uom_definition_special.has_key?(symbol)
    end

    ### -- Private class methods --

    @@_distance_uom_definition =
      { km: { description: 'Kilometer', synonyms: %w(k km kms kilometer kilometers) },
        m:  { description: 'Meter', synonyms: %w(m meter meters) },
        mi: { description: 'Mile', synonyms: %w(mi mile miles) },
        ft: { description: 'Feet', synonyms: %w(ft foot feet) }
      }

    @@_distance_uom_definition_special =
    {
        marathon: { description: 'Marathon', uom: :mi, factor: 26.2, synonyms: %w(marathon) }
    }

    private_class_method
    def self.distance_conversion_factors
      { km: 1.0,
        m:  0.001,
        mi: 1.609344,
        ft: 0.0003048 }
    end
  end
end
