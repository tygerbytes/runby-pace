module Runby
  module RunTypes
    # Your 5K race pace, which is also useful for running repetitions at this pace
    class FiveKilometerRaceRun < RunType
      def description
        '5K Race Pace'
      end

      def explanation
        'The 5K race (~3.1 miles) is an excellent gauge of overall fitness. Running repetitions of varying duration at 5K race pace can boost stroke volume, blood volume, mitochondrial and capillary density, etc.'
      end

      def lookup_pace(five_k_time, distance_units = :km)
        five_k_time = RunbyTime.new(five_k_time)
        pace = Pace.new(five_k_time / 5, '1km').convert_to(distance_units)
        PaceRange.new(pace, pace)
      end
    end
  end
end
