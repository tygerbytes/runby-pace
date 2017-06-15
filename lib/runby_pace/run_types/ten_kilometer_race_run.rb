module Runby
  module RunTypes
    # Your 10K race pace, which is also useful for running repetitions at this pace
    class TenKilometerRaceRun < RunType
      def description
        '10K Race Pace'
      end

      def explanation
        'Repetitions ran at 10K race pace (10 km is about 6.2 miles) are like 5K pace repetitions, but less intense. They elicit many of the same benefits and help increase speed in races from the 10K to the half-marathon.'
      end

      def lookup_pace(five_k_time, distance_units = :km)
        five_k_time = RunbyTime.new(five_k_time)
        ten_k_time = RunMath.predict_race_time('5K', five_k_time, '10K')
        pace = Pace.new(ten_k_time / 10, '1km').convert_to(distance_units)
        PaceRange.new(pace, pace)
      end
    end
  end
end
