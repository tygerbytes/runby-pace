module Runby
  # Represents a distance (distance UOM and multiplier)
  class Distance
    attr_reader :uom, :multiplier
    def initialize(uom = :km, multiplier = 1)
      raise 'Invalid multiplier' unless multiplier.is_a?(Numeric)
      case uom
        when Distance
          return init_from_clone uom
        when String
          return init_from_string uom
        when Symbol
          return init_from_symbol(uom, multiplier)
        else
          raise 'Invalid distance unit of measure'
      end
    end

    def meters
      kilometers = @multiplier * Runby::DistanceUnits.conversion_factor(@uom)
      kilometers * 1000.0
    end

    def self.parse(str)
      str = str.strip.chomp.downcase
      multiplier = str.scan(/[\d,.]+/).first.to_f
      uom = str.scan(/[-_a-z ]+$/).first
      raise "Unable to find distance unit in '#{str}'" if uom.nil?

      parsed_uom = Runby::DistanceUnits.parse uom
      raise "'#{uom.strip}' is not recognized as a distance unit" if parsed_uom[:uom].nil?

      self.new parsed_uom[:uom], parsed_uom[:factor] * multiplier
    end

    def to_s
      "#{format('%g', @multiplier.round(2))} #{pluralized_uom}"
    end

    def pluralized_uom
      uom_description = DistanceUnits.description(@uom).downcase
      if @multiplier > 1 then
        uom_description += 's'
      end
      uom_description
    end

    private

    def init_from_clone(distance)
      @uom = distance.uom
      @multiplier = distance.multiplier
    end

    def init_from_string(string)
      init_from_clone Distance.parse string
    end

    def init_from_symbol(distance_uom, multiplier)
      raise "Unknown unit of measure #{distance_uom}" unless Runby::DistanceUnits.known_uom? distance_uom
      @uom = distance_uom
      @multiplier = multiplier * 1.0
    end
  end
end
