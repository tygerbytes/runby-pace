# frozen_string_literal: true

module Runby
  # Represents a human-readable time in the format MM:ss
  class RunbyTime
    include Comparable

    attr_reader :time_s, :hours_part, :minutes_part, :seconds_part

    def self.new(time)
      return time if time.is_a? RunbyTime
      return RunbyTime.parse time if time.is_a?(String) || time.is_a?(Symbol)
      return from_minutes(time) if time.is_a? Numeric
      super
    end

    def initialize(time)
      init_from_parts time if time.is_a? RunbyTimeParser::TimeParts
      freeze
    end

    # @param [numeric] total_seconds
    def self.from_seconds(total_seconds)
      hours = total_seconds.abs.to_i / 60 / 60
      minutes = (total_seconds.abs.to_i / 60) % 60
      seconds = total_seconds.abs.to_i % 60
      if hours.positive?
        RunbyTime.new format('%d:%02d:%02d', hours, minutes, seconds)
      else
        RunbyTime.new format('%02d:%02d', minutes, seconds)
      end
    end

    # @param [numeric] total_minutes
    def self.from_minutes(total_minutes)
      from_seconds(total_minutes * 60.0)
    end

    # @param [numeric] total_hours
    def self.from_hours(total_hours)
      from_seconds(total_hours * 60.0 * 60.0)
    end

    def self.parse(str)
      RunbyTimeParser.parse str
    end

    def self.try_parse(str, is_five_k = false)
      time, error_message, warning_message = nil
      begin
        time = parse str
      rescue StandardError => ex
        error_message = "#{ex.message} (#{str})"
      end
      warning_message = check_5k_sanity(time) if !time.nil? && is_five_k
      { time: time, error: error_message, warning: warning_message }
    end

    def self.check_5k_sanity(time)
      return unless time.is_a? RunbyTime
      return '5K times of less than 14:00 are unlikely' if time.minutes_part < 14
      return '5K times of greater than 42:00 are not fully supported' if time.total_seconds > (42 * 60)
    end

    def to_s
      @time_s
    end

    def total_hours
      @hours_part + (@minutes_part / 60.0) + (@seconds_part / 60.0 / 60.0)
    end

    def total_seconds
      @hours_part * 60 * 60 + @minutes_part * 60 + @seconds_part
    end

    def total_minutes
      @hours_part * 60 + @minutes_part + (@seconds_part / 60.0)
    end

    # @param [RunbyTime] other
    def -(other)
      raise "Cannot subtract #{other.class} from a Runby::RunbyTime" unless other.is_a?(RunbyTime)
      RunbyTime.from_seconds(total_seconds - other.total_seconds)
    end

    # @param [RunbyTime] other
    def +(other)
      raise "Cannot add Runby::RunbyTime to a #{other.class}" unless other.is_a?(RunbyTime)
      RunbyTime.from_seconds(total_seconds + other.total_seconds)
    end

    # @param [Numeric] other
    # @return [RunbyTime]
    def *(other)
      raise "Cannot multiply Runby::RunbyTime with a #{other.class}" unless other.is_a?(Numeric)
      RunbyTime.from_minutes(total_minutes * other)
    end

    # @param [RunbyTime, Numeric] other
    # @return [Numeric, RunbyTime]
    def /(other)
      raise "Cannot divide Runby::RunbyTime by #{other.class}" unless other.is_a?(RunbyTime) || other.is_a?(Numeric)
      case other
      when RunbyTime
        total_seconds / other.total_seconds
      when Numeric
        RunbyTime.from_seconds(total_seconds / other)
      end
    end

    def <=>(other)
      raise "Unable to compare Runby::RunbyTime to #{other.class}(#{other})" unless [RunbyTime, String].include? other.class
      if other.is_a? RunbyTime
        total_seconds <=> other.total_seconds
      elsif other.is_a? String
        return 0 if @time_s == other
        total_seconds <=> RunbyTime.parse(other).total_seconds
      end
    end

    def almost_equals?(other_time, tolerance_time = '00:01')
      other_time = RunbyTime.new(other_time) if other_time.is_a?(String)
      tolerance = RunbyTime.new(tolerance_time)
      self >= (other_time - tolerance) && self <= (other_time + tolerance)
    end

    private

    # @param [RunbyTimeParser::TimeParts] parts
    def init_from_parts(parts)
      @time_s = parts.format
      @hours_part = parts[:hours]
      @minutes_part = parts[:minutes]
      @seconds_part = parts[:seconds]
    end
  end
end
