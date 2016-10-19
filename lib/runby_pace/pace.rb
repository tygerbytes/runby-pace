module Runby
  # Represents a pace consisting of a distance and a time in which that distance was covered
  class Pace
    include Comparable

    attr_reader :time, :distance

    def initialize(time_or_pace, distance = '1K')
      if time_or_pace.is_a? Pace
        init_from_clone time_or_pace
      else
        @time = Runby::RunbyTime.new(time_or_pace)
        @distance = Runby::Distance.new(distance)
      end
    end

    def to_s
      "#{time} per #{distance.pluralized_uom}"
    end

    def <=>(other)
      if other.is_a? Pace
        return nil unless @distance == other.distance
        @time <=> other.time
      elsif other.is_a? RunbyTime
        @time <=> other.time
      elsif other.is_a? String
        # TODO: Parse as Pace when Pace.parse is available
        @time <=> RunbyTime.parse(other)
      end
    end

    def almost_equals?(other_pace, tolerance_time = '00:01')
      if other_pace.is_a?(String)
        other_pace = Pace.parse(other_pace)
      end
      tolerance = RunbyTime.new(tolerance_time)
      self >= (other_pace - tolerance) && self <= (other_pace + tolerance)
    end

    # @param [Pace, RunbyTime] other
    def -(other)
      if other.is_a?(Pace)
        raise 'Pace arithmetic with different units is not currently supported' unless @distance == other.distance
        Pace.new(@time - other.time, @distance)
      elsif other.is_a?(RunbyTime)
        Pace.new(@time - other, @distance)
      end
    end

    # @param [Pace, RunbyTime] other
    def +(other)
      if other.is_a?(Pace)
        raise 'Pace arithmetic with different units is not currently supported' unless @distance == other.distance
        Pace.new(@time + other.time, @distance)
      elsif other.is_a?(RunbyTime)
        Pace.new(@time + other, @distance)
      end
    end

    private

    def init_from_clone(other_pace)
      raise "#{other_pace} is not a Runby::Pace" unless other_pace.is_a? Pace
      @time = other_pace.time
      @distance = other_pace.distance
    end
  end
end
