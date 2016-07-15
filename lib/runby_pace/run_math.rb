module RunbyPace

  class RunMath
    def self.convert_pace_to_speed(pace)
      pace = RunbyPace::PaceTime.new(pace)
      (60 / pace.total_minutes).round(2)
    end

    def self.convert_speed_to_pace(units_per_hour)
      raise 'units_per_hour must be numeric' unless units_per_hour.is_a? Numeric
      RunbyPace::PaceTime.from_minutes (60.0 / units_per_hour)
    end
  end

end
