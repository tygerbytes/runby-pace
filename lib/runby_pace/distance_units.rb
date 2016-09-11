module Runby
  # Represents the distance units (e.g. kilometers, miles) used in paces
  #  including the human-readable description of each unit
  #  and the factor used to convert it to kilometers.
  class DistanceUnits
    def self.description(uom)
      @@_uom_definitions[uom][:description]
    end

    def self.parse(description)
      description = description.strip.chomp
      found_uom = nil
      found_uom_factor = 1
      @@_uom_definitions.each do |uom, details|
        if details[:synonyms].include? description
          if details.has_key? :uom
            found_uom = details[:uom]
            found_uom_factor = details[:factor]
          else
            found_uom = uom
          end
          break
        end
      end
      { uom: found_uom, factor: found_uom_factor }
    end

    def self.conversion_factor(units)
      @@_uom_definitions[units][:conversion_factor]
    end

    def self.known_uom?(symbol)
      # TODO: test
      @@_uom_definitions.has_key?(symbol)
    end

    @@_uom_definitions =
      { km: { description: 'Kilometer', conversion_factor: 1.0, synonyms: %w(k km kms kilometer kilometers) },
        m:  { description: 'Meter', conversion_factor: 0.001, synonyms: %w(m meter meters) },
        mi: { description: 'Mile', conversion_factor: 1.609344, synonyms: %w(mi mile miles) },
        ft: { description: 'Feet', conversion_factor: 0.0003048, synonyms: %w(ft foot feet) },
        # Special UOMs, which just point to "real" UOMs in this hash table
        marathon: { description: 'Marathon', synonyms: %w(marathon), uom: :mi, factor: 26.2 }
      }
  end
end
