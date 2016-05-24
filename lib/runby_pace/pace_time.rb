module RunbyPace

  class PaceTime
    attr_reader :time_s, :minutes_part, :seconds_part

    def initialize(time)
      if time.is_a?(String) || time.is_a?(Symbol)
        init_from_string(time)
      elsif time.is_a?(PaceTime)
        init_from_clone(time)
      end
    end

    # @param [numeric] total_seconds
    def self.from_seconds(total_seconds)
      minutes = total_seconds.abs.to_i / 60
      seconds = total_seconds.abs.to_i % 60
      PaceTime.new("#{'%02d' % minutes}:#{'%02d' % seconds}")
    end

    def to_s
      @time_s
    end

    def total_seconds
      @minutes_part * 60 + @seconds_part
    end

    def total_minutes
      @minutes_part + (@seconds_part / 60.0)
    end

    # @param [PaceTime] value
    def -(value)
      if value.is_a?(PaceTime)
        PaceTime.from_seconds(total_seconds - value.total_seconds)
      end
    end

    # @param [PaceTime] value
    def +(value)
      if value.is_a?(PaceTime)
        PaceTime.from_seconds(total_seconds + value.total_seconds)
      end
    end

    def ==(value)
      if value.is_a?(PaceTime)
        total_seconds == value.total_seconds
      elsif value.is_a?(String)
        to_s == value
      end
    end

    def >(value)
      if value.is_a?(PaceTime)
        total_seconds > value.total_seconds
      end
    end

    def >=(value)
      if value.is_a?(PaceTime)
        total_seconds >= value.total_seconds
      end
    end

    def <(value)
      if value.is_a?(PaceTime)
        total_seconds < value.total_seconds
      end
    end

    def <=(value)
      if value.is_a?(PaceTime)
        total_seconds <= value.total_seconds
      end
    end

    private

    def init_from_string(time)
      raise 'Invalid time format' if !time.match(/(-)?\d\d:\d\d/)
      @time_s = time
      parts = time.to_s.split(':')
      @minutes_part = parts[0].to_i
      @seconds_part = parts[1].to_i
      raise 'Seconds must be less than 60' if @seconds_part.abs > 59
    end

    # @param [PaceTime] time
    def init_from_clone(time)
      @time = time.time_s
      @minutes_part = time.minutes_part
      @seconds_part = time.seconds_part
    end
  end
end
