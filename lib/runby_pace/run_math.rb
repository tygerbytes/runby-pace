module Runby
  # An assortment of mathematical functions related to running.
  class RunMath
    def self.convert_pace_to_speed(pace)
      pace = Runby::PaceTime.new(pace)
      (60 / pace.total_minutes).round(2)
    end

    def self.convert_speed_to_pace(units_per_hour)
      raise 'units_per_hour must be numeric' unless units_per_hour.is_a? Numeric
      Runby::PaceTime.from_minutes(60.0 / units_per_hour)
    end

    def self.distance_traveled(pace, time)
      # TODO: I sense the need for a refactor...
      #  Consider extracting a new Pace class, which consists of Time + Units
      #  Then move this method to the new class, and give it a better name.
      pace = Runby::PaceTime.new(pace)
      time = Runby::PaceTime.new(time)

      divisor = pace.total_minutes / time.total_minutes
      distance_units_traveled = 1 / divisor
      return distance_units_traveled
    end
  end
end
