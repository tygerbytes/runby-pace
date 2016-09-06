module Runby
  # Represents a distance (distance UOM and multiplier)
  class Distance
    attr_reader :uom, :multiplier
    def initialize(distance_uom = :km, multiplier = 1)
      # TODO: Test and cleanup
      if distance_uom.is_a? Distance
        return init_from_clone distance_uom
      end

      raise 'Invalid distance unit of measure' unless [String, Symbol].include? distance_uom.class
      raise 'Invalid multiplier' unless multiplier.is_a?(Numeric)

      if distance_uom.is_a? Symbol
        raise "Unknown unit of measure #{distance_uom}" unless Runby::DistanceUnits.known_uom? distance_uom
        @uom = distance_uom
        @multiplier = multiplier * 1.0
        return
      end

      distance = Distance.parse distance_uom
      @uom = distance.uom
      @multiplier = distance.multiplier
    end

    def meters
      kilometers = @multiplier * Runby::DistanceUnits.conversion_factor(@uom)
      kilometers * 1000.0
    end

    def self.parse(str)
      str = str.strip.chomp.downcase
      # TODO: handle multipliers with commas/spaces
      multiplier = str.scan(/[\d,.]+/).first.to_f
      uom = str.scan(/[-_a-z ]+$/).first
      # TODO: test V
      raise "Unable to find distance unit in #{str}" if uom.nil?

      parsed_uom = Runby::DistanceUnits.parse uom
      # TODO: test
      raise "#{uom} is not recognized as a distance unit" if parsed_uom[:uom].nil?

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
  end
end
