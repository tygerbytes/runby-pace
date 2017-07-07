# frozen_string_literal: true

module Runby
  # Represents the distance units (e.g. kilometers, miles) used in paces
  #  including the human-readable description of each unit
  #  and the factor used to convert it to kilometers.
  class DistanceUnit
    attr_reader :symbol, :description, :conversion_factor

    def initialize(unit_of_measure)
      if unit_of_measure.is_a? Symbol
        init_from_symbol unit_of_measure
      elsif unit_of_measure.is_a? String
        init_from_string unit_of_measure
      end
      @conversion_factor = UOM_DEFINITIONS[@symbol][:conversion_factor]
      @description = UOM_DEFINITIONS[@symbol][:description]
      freeze
    end

    def to_s(format: :long, pluralize: false)
      case format
      when :short then @symbol.to_s
      when :long then pluralize ? description_plural : @description
      end
    end

    def description_plural
      UOM_DEFINITIONS[@symbol][:description_plural]
    end

    def self.parse(description)
      return new description if description.is_a? Symbol
      description = description.strip.chomp.downcase
      found_uom = nil
      UOM_DEFINITIONS.each do |uom, details|
        if details[:synonyms].include? description
          found_uom = uom
          break
        end
      end
      raise "Error parsing distance unit '#{description}'" unless found_uom
      DistanceUnit.new found_uom
    end

    def self.try_parse(str)
      uom, error_message = nil
      begin
        uom = parse str
      rescue StandardError => ex
        error_message = ex.message
      end
      { uom: uom, error: error_message }
    end

    def self.known_uom?(symbol)
      UOM_DEFINITIONS.key?(symbol)
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

    UOM_DEFINITIONS =
      { km: { description: 'kilometer', description_plural: 'kilometers', conversion_factor: 1.0,
              synonyms: %w[k km kms kilometer kilometers] },
        m:  { description: 'meter', description_plural: 'meters', conversion_factor: 0.001,
              synonyms: %w[m meter meters] },
        mi: { description: 'mile', description_plural: 'miles', conversion_factor: 1.609344,
              synonyms: %w[mi mile miles] },
        ft: { description: 'foot', description_plural: 'feet', conversion_factor: 0.0003048,
              synonyms: %w[ft foot feet] },
        yd: { description: 'yard', description_plural: 'yards', conversion_factor: 1093.61,
              synonyms: %w[y yd yds yard yards] },
        # Fun distance unit of measures
        marathon: { description: 'marathon', description_plural: 'marathons', conversion_factor: 42.1648128,
                    synonyms: %w[marathon] } }.freeze

    private

    def init_from_symbol(unit_of_measure)
      raise "':#{unit_of_measure}' is an unknown unit of measure" unless DistanceUnit.known_uom? unit_of_measure
      @symbol = unit_of_measure
    end

    def init_from_string(unit_of_measure)
      parsed_uom = DistanceUnit.parse(unit_of_measure)
      @symbol = parsed_uom.symbol
    end
  end
end
