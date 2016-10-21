module Runby
  # Represents the distance units (e.g. kilometers, miles) used in paces
  #  including the human-readable description of each unit
  #  and the factor used to convert it to kilometers.
  class DistanceUnit
    attr_reader :symbol, :description, :conversion_factor

    def initialize(unit_of_measure)
      if unit_of_measure.is_a? Symbol
        raise "':#{unit_of_measure.to_s}' is an unknown unit of measure" unless DistanceUnit.known_uom? unit_of_measure
        @symbol = unit_of_measure
        @conversion_factor = @@_uom_definitions[@symbol][:conversion_factor]
      elsif unit_of_measure.is_a? String
        parsed_uom = DistanceUnit.parse(unit_of_measure)
        @symbol = parsed_uom.symbol
        @conversion_factor = @@_uom_definitions[@symbol][:conversion_factor]
      end

      @description = @@_uom_definitions[@symbol][:description]
    end

    def to_s(format = :long)
      case format
        when :short then @symbol.to_s
        when :long then @description
      end
    end

    def self.parse(description)
      description = description.strip.chomp.downcase
      found_uom = nil
      @@_uom_definitions.each do |uom, details|
        if details[:synonyms].include? description
          found_uom = uom
          break
        end
      end
      raise "Error parsing distance unit '#{description}'" unless found_uom
      return DistanceUnit.new found_uom
    end

    def self.try_parse(str)
      uom, error_message = nil
      begin
        uom = parse str
      rescue StandardError => ex
        error_message = "#{ex.message}"
      end
      { uom: uom, error: error_message }
    end

    def self.known_uom?(symbol)
      # TODO: test
      @@_uom_definitions.has_key?(symbol)
    end

    def ==(other)
      if other.is_a? DistanceUnit
        @symbol == other.symbol
      elsif other.is_a? String
        @symbol == DistanceUnit.parse(other)
      else
        raise "Error comparing DistanceUnit to #{other.class}"
      end
    end

    @@_uom_definitions =
      { km: { description: 'Kilometer', conversion_factor: 1.0, synonyms: %w(k km kms kilometer kilometers) },
        m:  { description: 'Meter', conversion_factor: 0.001, synonyms: %w(m meter meters) },
        mi: { description: 'Mile', conversion_factor: 1.609344, synonyms: %w(mi mile miles) },
        ft: { description: 'Feet', conversion_factor: 0.0003048, synonyms: %w(ft foot feet) },
        yd: { description: 'Yards', conversion_factor: 1093.61, synonyms: %w(y yd yds yard yards) },
        # Fun distance unit of measures
        marathon: { description: 'Marathon', conversion_factor: 42.1648128, synonyms: %w(marathon) }
      }
  end
end
