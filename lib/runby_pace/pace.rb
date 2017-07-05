module Runby
  # Represents a pace consisting of a distance and a time in which that distance was covered
  class Pace
    include Comparable

    attr_reader :time, :distance

    def initialize(time_or_pace, distance = '1K')
      case time_or_pace
      when Pace
        init_from_clone time_or_pace
      when RunbyTime
        init_from_time time_or_pace, distance
      when String
        init_from_string time_or_pace, distance
      else
        raise 'Invalid Time or Pace'
      end
    end

    def convert_to(target_distance)
      target_distance = Distance.new(target_distance) unless target_distance.is_a?(Distance)
      return self if @distance == target_distance
      conversion_factor = target_distance / @distance
      Pace.new @time * conversion_factor, target_distance
    end

    def to_s(format: :short)
      distance_s = @distance.to_s(format: format)
      leading_one_regex = /^1 ?/
      distance_s.gsub!(leading_one_regex, '')
      case format
      when :short then "#{time} p/#{distance_s}"
      when :long then "#{time} per #{distance_s}"
      end
    end

    def as_speed
      total_minutes = @time.total_minutes
      multiplier = total_minutes.positive? ? (60 / total_minutes).round(2) : 0
      distance = Runby::Distance.new(@distance.uom, multiplier)
      Runby::Speed.new distance
    end

    def meters_per_minute
      total_minutes = @time.total_minutes
      return 0 unless total_minutes.positive?
      @distance.meters / total_minutes
    end

    # @param [String] str is either a long-form pace such as "10:00 per mile" or a short-form pace like "10:00 p/mi"
    def self.parse(str)
      str = str.to_s.strip.chomp
      match = str.match %r{^(?<time>[:\d]*) ?(?: per |p\/)(?<distance>(?:[\d.]+ ?)?\w+)$}
      raise "Invalid pace format (#{str})" unless match
      time = Runby::RunbyTime.new(match[:time])
      distance = Runby::Distance.new(match[:distance])
      Pace.new time, distance
    end

    def self.try_parse(str)
      pace = nil
      error_message = nil
      warning_message = nil
      begin
        pace = Pace.parse str
      rescue StandardError => ex
        error_message = ex.message
      end
      { pace: pace, error: error_message, warning: warning_message }
    end

    def <=>(other)
      if other.is_a? Pace
        meters_per_minute.round(2) <=> other.meters_per_minute.round(2)
      elsif other.is_a? RunbyTime
        @time <=> other.time
      elsif other.is_a? String
        return 0 if to_s == other || to_s(format: :long) == other
        return 0 if @time == other
        self <=> try_parse(other)[:pace]
      end
    end

    def almost_equals?(other_pace, tolerance_time = '00:01')
      if other_pace.is_a?(RunbyTime)
        return almost_equals?(Pace.new(other_pace, @distance), tolerance_time)
      end
      if other_pace.is_a?(String)
        return almost_equals?(Pace.new(other_pace, @distance), tolerance_time) if other_pace.match?(/^\d?\d:\d\d$/)
        other_pace = Pace.parse(other_pace)
      end
      tolerance = RunbyTime.new(tolerance_time)
      fast_end = (self - tolerance)
      slow_end = (self + tolerance)
      slow_end <= other_pace && other_pace <= fast_end
    end

    # @param [Pace, RunbyTime] other
    def -(other)
      if other.is_a?(Pace)
        Pace.new(@time - other.convert_to(@distance).time, @distance)
      elsif other.is_a?(RunbyTime)
        Pace.new(@time - other, @distance)
      end
    end

    # @param [Pace, RunbyTime] other
    def +(other)
      if other.is_a?(Pace)
        Pace.new(@time + other.convert_to(@distance).time, @distance)
      elsif other.is_a?(RunbyTime)
        Pace.new(@time + other, @distance)
      end
    end

    def distance_covered_over_time(time)
      time = Runby::RunbyTime.new(time)
      if time.total_minutes.zero? || @distance.multiplier.zero?
        return Runby::Distance.new(@distance.uom, 0)
      end
      divisor = @time.total_minutes / time.total_minutes / @distance.multiplier
      distance_covered = Runby::Distance.new(@distance.uom, 1 / divisor)
      distance_covered
    end

    private

    def init_from_clone(other_pace)
      raise "#{other_pace} is not a Runby::Pace" unless other_pace.is_a? Pace
      @time = other_pace.time
      @distance = other_pace.distance
    end

    def init_from_string(string, distance = '1K')
      pace = Pace.try_parse(string)
      if pace[:pace]
        @time = pace[:pace].time
        @distance = pace[:pace].distance
        return
      end
      @time = Runby::RunbyTime.new string
      @distance = Runby::Distance.new distance
    end

    def init_from_time(time, distance)
      @time = time
      @distance = Runby::Distance.new distance
    end
  end
end
