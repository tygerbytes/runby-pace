module Runby
  module RunTypes
    # Defines the venerable "distance run", the backbone of any distance running program.
    #  Most of your runs should be at this pace. Harder than an "easy run" but still conversational.
    class DistanceRun < RunType
      attr_reader :slow_pace_data, :fast_pace_data

      def description
        'Distance Run'
      end

      def initialize
        @fast_pace_data = PaceCalculator.new(GoldenPaces.fast[:'14:00'], GoldenPaces.fast[:'42:00'], 3.675)
        @slow_pace_data = PaceCalculator.new(GoldenPaces.slow[:'14:00'], GoldenPaces.slow[:'42:00'], 2.175)
      end

      def pace(five_k_time, distance_units = :km)
        fast = @fast_pace_data.calc(five_k_time, distance_units)
        slow = @slow_pace_data.calc(five_k_time, distance_units)
        PaceRange.new(fast, slow)
      end

      # Used in testing, contains hashes mapping 5K race times with the recommended pace-per-km for this run type.
      class GoldenPaces
        def self.fast
          { '14:00': '03:44', '15:00': '03:58', '20:00': '05:09', '25:00': '06:18', '30:00': '07:24', '35:00': '08:29', '40:00': '09:33', '42:00': '09:58' }
        end

        def self.slow
          { '14:00': '04:17', '15:00': '04:33', '20:00': '05:53', '25:00': '07:09', '30:00': '08:23', '35:00': '09:33', '40:00': '10:42', '42:00': '11:10' }
        end
      end
    end
  end
end
