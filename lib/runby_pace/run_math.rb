# frozen_string_literal: true

module Runby
  # An assortment of mathematical functions related to running.
  class RunMath
    def self.predict_race_time(race1_distance, race1_time, target_distance)
      race1_distance = Runby.sanitize(race1_distance).as(Distance)
      race1_time = Runby.sanitize(race1_time).as(RunbyTime)
      target_distance = Runby.sanitize(target_distance).as(Distance)

      race1_time * (target_distance / race1_distance)**1.06
    end
  end
end
