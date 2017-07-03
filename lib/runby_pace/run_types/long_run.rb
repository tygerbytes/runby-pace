module Runby
  module RunTypes
    # Arguably one of the most important run types, the "long run" is harder than an "easy run", but easier than
    #  a "distance run". It should remain conversational.
    class LongRun < RunType
      attr_reader :slow_pace_calculator, :fast_pace_calculator

      def description
        'Long Run'
      end

      def explanation
        'For many runners, the long run is the favorite run of the week. It is usually only ran once per week, and accounts for 20-25% of your weekly training volume. Remember that it\'s not a race. It should remain comfortable.'
      end

      def initialize
        @fast_pace_calculator = PaceCalculator.new(GoldenPaces.fast, 2.125)
        @slow_pace_calculator = PaceCalculator.new(GoldenPaces.slow, 1.55)
      end

      def lookup_pace(five_k_time, distance_units = :km)
        fast = @fast_pace_calculator.calc(five_k_time, distance_units)
        slow = @slow_pace_calculator.calc(five_k_time, distance_units)
        PaceRange.new(fast, slow)
      end

      # Used in testing, contains hashes mapping 5K race times with the recommended pace-per-km for this run type.
      class GoldenPaces
        def self.fast
          GoldenPaceSet.new('14:00': '04:00',
                            '15:00': '04:16',
                            '20:00': '05:31',
                            '25:00': '06:44',
                            '30:00': '07:54',
                            '35:00': '09:01',
                            '40:00': '10:07',
                            '42:00': '10:32')
        end

        def self.slow
          GoldenPaceSet.new('14:00': '04:39',
                            '15:00': '04:57',
                            '20:00': '06:22',
                            '25:00': '07:43',
                            '30:00': '09:00',
                            '35:00': '10:15',
                            '40:00': '11:26',
                            '42:00': '11:53')
        end
      end
    end
  end
end
