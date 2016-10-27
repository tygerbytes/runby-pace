module Runby
  # Represents a speed consisting of a distance and a unit of time in which that distance was covered
  class Speed
    include Comparable

    attr_reader :distance

    def initialize(distance_or_multiplier, units = :km)
      case distance_or_multiplier
        when Distance
          init_from_distance distance_or_multiplier
        when String
          init_from_string distance_or_multiplier
        when Numeric
          init_from_multiplier(distance_or_multiplier, units)
        when Speed
          init_from_clone distance_or_multiplier
        else
          raise 'Unable to initialize Runby::Speed'
      end
    end

    def to_s(format: :long)
      distance = @distance.to_s(format: format)
      case format
        when :short then "#{distance}/ph"
        when :long then "#{distance} per hour"
      end
    end

    def self.try_parse(description)
      # TODO: hard coding
      distance = Distance.new(:mi, 7)
      speed = Speed.new distance
      { speed: speed }
    end

    private

    def init_from_clone(other_speed)
      @distance = Distance.new(other_speed.distance)
    end

    def init_from_distance(distance)
      @distance = distance
    end

    def init_from_multiplier(multiplier, uom)
      @distance = Distance.new(uom, multiplier)
    end

    def init_from_string(str)
      results = Speed.try_parse(str)
      unless results[:error]
        init_from_clone results[:speed]
        return
      end
      results = Distance.try_parse(str)
      unless results[:error]
        init_from_distance results[:distance]
        return
      end
      raise "'#{str}' is not recognized as a Speed"
    end
  end
end
