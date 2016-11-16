module Runby
  # An assortment of mathematical functions related to running.
  class RunMath
    def self.convert_pace_to_speed(pace)
      pace.as_speed
    end

    def self.convert_speed_to_pace(speed)
      speed.as_pace
    end

    def self.distance_traveled(pace, time)
      # TODO: I sense the need for a refactor...
      #  Consider extracting a new Pace class, which consists of Time + Units
      #  Then move this method to the new class, and give it a better name.
      pace = Runby::RunbyTime.new(pace)
      time = Runby::RunbyTime.new(time)

      divisor = pace.total_minutes / time.total_minutes
      distance_units_traveled = 1 / divisor
      return distance_units_traveled
    end
  end
end
