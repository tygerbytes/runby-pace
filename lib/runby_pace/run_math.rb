module RunbyPace

  class RunMath
    def self.convert_pace_to_speed(pace)
      pace = RunbyPace::PaceTime.new(pace)
      (60 / pace.total_minutes).round(2)
    end
  end

end
