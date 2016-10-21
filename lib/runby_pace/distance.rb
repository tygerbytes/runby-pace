module Runby
  # Represents a distance (distance UOM and multiplier)
  class Distance
    attr_reader :uom, :multiplier
    def initialize(uom = :km, multiplier = 1)
      case uom
        when Distance
          return init_from_clone uom
        when DistanceUnit
          return init_from_distance_unit uom, multiplier
        when String
          return init_from_string uom
        when Symbol
          return init_from_symbol uom, multiplier
        else
          raise 'Invalid distance unit of measure'
      end
    end

    def convert_to(uom)
      target_uom = DistanceUnit.new uom
      target_multiplier = kilometers / (target_uom.conversion_factor * 1.0)
      Distance.new target_uom, target_multiplier
    end

    def meters
      kilometers * 1000.0
    end

    def kilometers
      @multiplier * @uom.conversion_factor
    end

    def self.parse(str)
      str = str.strip.chomp.downcase
      multiplier = str.scan(/[\d,.]+/).first.to_f
      uom = str.scan(/[-_a-z ]+$/).first
      raise "Unable to find distance unit in '#{str}'" if uom.nil?

      parsed_uom = Runby::DistanceUnit.parse uom
      raise "'#{uom.strip}' is not recognized as a distance unit" if parsed_uom.nil?

      self.new parsed_uom, multiplier
    end

    def self.try_parse(str)
      distance, error_message = nil
      begin
        distance = parse str
      rescue StandardError => ex
        error_message = "#{ex.message}"
      end
      { distance: distance, error: error_message }
    end

    def to_s(format = :long)
      formatted_multiplier = format('%g', @multiplier.round(2))
      case format
        when :short then "#{formatted_multiplier}#{@uom.to_s(format)}"
        when :long then "#{formatted_multiplier} #{@uom.to_s(format, plural = (@multiplier > 1))}"
      end
    end

    def ==(other)
      raise "Cannot compare Runby::Distance to #{other.class}" unless other.is_a? Distance
      @uom == other.uom && @multiplier == other.multiplier
    end

    private

    def init_from_clone(distance)
      @uom = distance.uom
      @multiplier = distance.multiplier
    end

    def init_from_distance_unit(uom, multiplier)
      @uom = uom
      @multiplier = multiplier
    end

    def init_from_string(string)
      init_from_clone Distance.parse string
    end

    def init_from_symbol(distance_uom_symbol, multiplier)
      raise "Unknown unit of measure #{distance_uom_symbol}" unless Runby::DistanceUnit.known_uom? distance_uom_symbol
      raise 'Invalid multiplier' unless multiplier.is_a?(Numeric)
      @uom = DistanceUnit.new distance_uom_symbol
      @multiplier = multiplier * 1.0
    end
  end
end
