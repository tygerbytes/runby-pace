require_relative 'tempo_run'

module Runby
  module RunTypes
    # The "fast tempo" pace roughly equates to your half-marathon pace.
    #  It's a pace you could maintain for about an hour, if pressed.
    class FastTempoRun < TempoRun
      def description
        'Fast Tempo Run'
      end

      def explanation
        'The fast tempo run is an interval workout of 15-25 minutes per repetition. The pace roughly corresponds to that of your half-marathon race pace.'
      end

      def lookup_pace(five_k_time, distance_units = :km)
        fast = @fast_pace_calculator.calc(five_k_time, distance_units)
        PaceRange.new(fast, fast)
      end
    end
  end
end
