# frozen_string_literal: true

module Runby
  # Represents a speed consisting of a distance and a unit of time in which that distance was covered
  class Speed
    include Comparable

    attr_reader :distance

    def self.new(distance_or_multiplier, units = :km)
      return distance_or_multiplier if distance_or_multiplier.is_a? Speed
      if distance_or_multiplier.is_a? String
        parsed_speed = Speed.try_parse(distance_or_multiplier)
        return parsed_speed[:speed] unless parsed_speed[:error]
      end
      super
    end

    def initialize(distance_or_multiplier, units = :km)
      case distance_or_multiplier
      when Distance
        init_from_distance distance_or_multiplier
      when String
        # Already tried to parse it as a Speed string. Try parsing it as a Distance string.
        init_from_distance_string distance_or_multiplier
      when Numeric
        init_from_multiplier(distance_or_multiplier, units)
      else
        raise 'Unable to initialize Runby::Speed'
      end
      freeze
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
      match = str.match(%r{^(?<distance>\d+(?:\.\d+)? ?[A-Za-z]+)(?: per hour|\/ph)$})
      raise "Invalid speed format (#{str})" unless match
      distance = Runby::Distance.new(match[:distance])
      Speed.new distance
    end

    def self.try_parse(str)
      speed = nil
      error_message = nil
      warning_message = nil
      begin
        speed = Speed.parse str
      rescue StandardError => ex
        error_message = "#{ex.message} (#{str})"
      end
      { speed: speed, error: error_message, warning: warning_message }
    end

    def <=>(other)
      raise "Cannot compare Runby::Speed to #{other.class}" unless [Speed, String].include? other.class
      if other.is_a? String
        return 0 if to_s == other.to_s || to_s(format: :long) == other.to_s(format: :long)
        self <=> try_parse(other)[:speed]
      end
      @distance <=> other.distance
    end

    private

    def init_from_distance(distance)
      @distance = distance
    end

    def init_from_multiplier(multiplier, uom)
      @distance = Distance.new(uom, multiplier)
    end

    def init_from_distance_string(str)
      results = Distance.try_parse(str)
      unless results[:error]
        @distance = results[:distance]
        return
      end
      raise "'#{str}' is not recognized as a Speed"
    end
  end
end
