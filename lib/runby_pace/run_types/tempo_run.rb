# frozen_string_literal: true

module Runby
  module RunTypes
    # Combines the fast and slow tempo runs into one convenient range of paces
    class TempoRun < RunType
      attr_reader :slow_pace_calculator, :fast_pace_calculator

      def description
        'Tempo Run'
      end

      def explanation
        'Ran at a comfortably hard pace that you could maintain for about an hour, if pressed. However, tempo runs are interval workouts, so you won\'t run for longer than 15-40 minutes per repetition'
      end

      def initialize
        @fast_pace_calculator = PaceCalculator.new(GoldenPaces.fast, 4.025)
        @slow_pace_calculator = PaceCalculator.new(GoldenPaces.slow, 3.725)
      end

      def lookup_pace(five_k_time, distance_units = :km)
        fast = @fast_pace_calculator.calc(five_k_time, distance_units)
        slow = @slow_pace_calculator.calc(five_k_time, distance_units)
        PaceRange.new(fast, slow)
      end

      # Used in testing, contains hashes mapping 5K race times with the recommended pace-per-km for this run type.
      class GoldenPaces
        def self.fast
          GoldenPaceSet.new('14:00': '03:07',
                            '15:00': '03:20',
                            '20:00': '04:21',
                            '25:00': '05:20',
                            '30:00': '06:19',
                            '35:00': '07:16',
                            '40:00': '08:12',
                            '42:00': '08:35')
        end

        def self.slow
          GoldenPaceSet.new('14:00': '03:18',
                            '15:00': '03:31',
                            '20:00': '04:35',
                            '25:00': '05:37',
                            '30:00': '06:38',
                            '35:00': '07:38',
                            '40:00': '08:36',
                            '42:00': '08:59')
        end
      end
    end
  end
end
