# frozen_string_literal: true

module Runby
  module RunTypes
    # An easy run is basically a jog. It should be conversational.
    class EasyRun < RunType
      attr_reader :slow_pace_calculator, :fast_pace_calculator

      def description
        'Easy Run'
      end

      def explanation
        'Also called a recovery run, the easy run is harder than jogging, but you should still be able to carry on a conversation.'
      end

      def initialize
        @fast_pace_calculator = PaceCalculator.new(GoldenPaces.fast, 1.99)
        @slow_pace_calculator = PaceCalculator.new(GoldenPaces.slow, 1.35)
      end

      def lookup_pace(five_k_time, distance_units = :km)
        fast = @fast_pace_calculator.calc(five_k_time, distance_units)
        slow = @slow_pace_calculator.calc(five_k_time, distance_units)
        PaceRange.new(fast, slow)
      end

      # Used in testing, contains hashes mapping 5K race times with the recommended pace-per-km for this run type.
      class GoldenPaces
        def self.fast
          GoldenPaceSet.new('14:00': '04:17',
                            '15:00': '04:33',
                            '20:00': '05:53',
                            '25:00': '07:09',
                            '30:00': '08:23',
                            '35:00': '09:33',
                            '40:00': '10:41',
                            '42:00': '11:08')
        end

        def self.slow
          GoldenPaceSet.new('14:00': '05:01',
                            '15:00': '05:20',
                            '20:00': '06:51',
                            '25:00': '08:17',
                            '30:00': '09:38',
                            '35:00': '10:56',
                            '40:00': '12:10',
                            '42:00': '12:39')
        end
      end
    end
  end
end
