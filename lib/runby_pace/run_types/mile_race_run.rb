# frozen_string_literal: true

module Runby
  module RunTypes
    # Your mile race pace, which is also useful for running repetitions at this pace
    class MileRaceRun < RunType
      def description
        'Mile Race Pace'
      end

      def explanation
        'Repetitions run at a pace you would use to race one mile can increase the stroke volume of your heart, strengthen your lungs, increase the number of capillaries around your intermediate and fast twitch fibers, and increase mitochondrial densities around the same.'
      end

      def lookup_pace(five_k_time, distance_units = :km)
        five_k_time = RunbyTime.new(five_k_time)
        mile = Distance.new('1 mile')
        mile_time = RunMath.predict_race_time('5K', five_k_time, mile)
        pace = Pace.new(mile_time, mile).convert_to(distance_units)
        PaceRange.new(pace, pace)
      end
    end
  end
end
