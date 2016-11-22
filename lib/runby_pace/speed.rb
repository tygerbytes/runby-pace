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

    def to_s(format: :short)
      distance = @distance.to_s(format: format)
      case format
        when :short then "#{distance}/ph"
        when :long then "#{distance} per hour"
      end
    end

    def as_pace
      time = Runby::RunbyTime.from_minutes(60.0 / @distance.multiplier)
      Runby::Pace.new(time, @distance.uom)
    end


    # @param [String] str is either a long-form speed such as "7.5 miles per hour" or a short-form speed like "7.5mi/ph"
    def self.parse(str)
      str = str.to_s.strip.chomp
      if str.match(/^(?<distance>\d+(?:\.\d+)? ?[A-Za-z]+)(?: per hour|\/ph)$/)
        distance = Runby::Distance.new($~[:distance])
        Speed.new distance
      else
        raise "Invalid speed format (#{str})"
      end
    end

    def self.try_parse(str)
      speed, error_message = nil, warning_message = nil
      begin
        speed = Speed.parse str
      rescue StandardError => ex
        error_message = "#{ex.message} (#{str})"
      end
      { speed: speed, error: error_message, warning: warning_message }
    end

    def <=>(other)
      if other.is_a? Speed
        @distance <=> other.distance
      elsif other.is_a? String
        # TODO: Parse as Speed when Speed.parse is available
        to_s(format: :short) <=> other || to_s(format: :long) <=> other
      end
    end

    private

    def init_from_clone(other_speed)
      @distance = Distance.new(other_speed.distance)
    end

    def init_from_distance(distance)
      @distance = Distance.new(distance)
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
