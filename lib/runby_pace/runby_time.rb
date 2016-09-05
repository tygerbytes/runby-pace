module Runby
  # Represents a human-readable time in the format MM:ss
  class RunbyTime
    attr_reader :time_s, :minutes_part, :seconds_part

    def initialize(time)
      if time.is_a?(String) || time.is_a?(Symbol)
        init_from_string time
      elsif time.is_a?(RunbyTime)
        init_from_clone time
      elsif time.is_a?(Hash)
        init_from_hash time
      end
    end

    # @param [numeric] total_seconds
    def self.from_seconds(total_seconds)
      minutes = total_seconds.abs.to_i / 60
      seconds = total_seconds.abs.to_i % 60
      RunbyTime.new format('%02d:%02d', minutes, seconds)
    end

    # @param [numeric] total_minutes
    def self.from_minutes(total_minutes)
      from_seconds(total_minutes * 60.0)
    end

    def self.parse(str)
      time = str.to_s.strip.chomp

      if time.match(/^\d?\d:\d\d$/)
        parts = time.split(':')
        minutes_part = parts[0].to_i
        seconds_part = parts[1].to_i
      elsif time.match(/^\d+$/)
        minutes_part = time.to_i
        seconds_part = 0
      elsif time.match(/^\d+[,. ]\d+$/)
        parts = time.split(/[,. ]/)
        minutes_part = parts[0].to_i
        seconds_part = (parts[1].to_i / 10.0 * 60).to_i
      else
        raise 'Invalid time format'
      end

      raise 'Minutes must be less than 100' if minutes_part > 99
      raise 'Seconds must be less than 60' if seconds_part > 59
      time_formatted = "#{minutes_part.to_s.rjust(2, '0')}:#{seconds_part.to_s.rjust(2, '0')}"

      RunbyTime.new(time_s: time_formatted, minutes_part: minutes_part, seconds_part: seconds_part)
    end

    def self.try_parse(str, is_five_k = false)
      time, error_message, warning_message = nil
      begin
        time = parse str
      rescue StandardError => ex
        error_message = "#{ex.message} (#{str})"
      end

      # Break out these sanity checks into their own class if we add any more.
      if !time.nil? && is_five_k
        warning_message = '5K times of less than 14:00 are unlikely' if time.minutes_part < 14
        warning_message = '5K times of greater than 42:00 are not fully supported' if time.total_seconds > (42 * 60)
      end

      { time: time, error: error_message, warning: warning_message }
    end

    def to_s
      @time_s.sub(/^[0:]*/, '')
    end

    def total_seconds
      @minutes_part * 60 + @seconds_part
    end

    def total_minutes
      @minutes_part + (@seconds_part / 60.0)
    end

    # @param [RunbyTime] other
    def -(other)
      if other.is_a?(RunbyTime)
        RunbyTime.from_seconds(total_seconds - other.total_seconds)
      end
    end

    # @param [RunbyTime] other
    def +(other)
      if other.is_a?(RunbyTime)
        RunbyTime.from_seconds(total_seconds + other.total_seconds)
      end
    end

    def ==(other)
      if other.is_a?(RunbyTime)
        total_seconds == other.total_seconds
      elsif other.is_a?(String)
        @time_s == other
      end
    end

    def almost_equals?(other_time, tolerance_time = '00:01')
      if other_time.is_a?(String)
        other_time = RunbyTime.new(other_time)
      end
      tolerance = RunbyTime.new(tolerance_time)
      self >= (other_time - tolerance) && self <= (other_time + tolerance)
    end

    def >(other)
      if other.is_a?(RunbyTime)
        total_seconds > other.total_seconds
      end
    end

    def >=(other)
      if other.is_a?(RunbyTime)
        total_seconds >= other.total_seconds
      end
    end

    def <(other)
      if other.is_a?(RunbyTime)
        total_seconds < other.total_seconds
      end
    end

    def <=(other)
      if other.is_a?(RunbyTime)
        total_seconds <= other.total_seconds
      end
    end

    private

    # @param [Hash] params
    def init_from_hash(params = {})
      @time_s = params.fetch :time_s, '00:00'
      @minutes_part = params.fetch :minutes_part, 0.0
      @seconds_part = params.fetch :seconds_part, 0.0
    end

    # @param [RunbyTime] time
    def init_from_clone(time)
      @time_s = time.time_s
      @minutes_part = time.minutes_part
      @seconds_part = time.seconds_part
    end

    # @param [String] time
    def init_from_string(time)
      init_from_clone RunbyTime.parse time
    end
  end
end
