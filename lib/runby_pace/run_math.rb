module Runby
  # An assortment of mathematical functions related to running.
  class RunMath
    def self.predict_race_time(race1_distance, race1_time, target_distance)
      race1_distance = Distance.new(race1_distance)
      race1_time = RunbyTime.new(race1_time)
      target_distance = Distance.new(target_distance)

      race1_time * (target_distance / race1_distance)**1.06
    end
  end
end
