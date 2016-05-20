module RunbyPace

  class PaceTime
    attr_reader :time_s, :minutes_part, :seconds_part

    def initialize(time)
      raise 'Invalid time format' if !time.match(/(-)?\d\d:\d\d/)
      @time_s = time
      parts = time.to_s.split(':')
      @minutes_part = parts[0].to_i
      @seconds_part = parts[1].to_i
      raise 'Seconds must be less than 60' if @seconds_part.abs > 59
    end

    def to_s
      @time_s
    end

    def total_seconds
      @minutes_part * 60 + @seconds_part
    end
  end
end
