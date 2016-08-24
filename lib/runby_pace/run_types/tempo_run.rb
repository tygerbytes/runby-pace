module Runby
  module RunTypes
    # Combines the fast and slow tempo runs into one convenient range of paces
    class TempoRun < RunType
      attr_reader :slow_pace_data, :fast_pace_data

      def description
        'Tempo Run'
      end

      def initialize
        @fast_pace_data = PaceData.new(GoldenPaces.fast[:'14:00'], GoldenPaces.fast[:'42:00'], 4.025)
        @slow_pace_data = PaceData.new(GoldenPaces.slow[:'14:00'], GoldenPaces.slow[:'42:00'], 3.725)
      end

      def pace(five_k_time, distance_units = :km)
        fast = @fast_pace_data.calc(five_k_time, distance_units)
        slow = @slow_pace_data.calc(five_k_time, distance_units)
        PaceRange.new(fast, slow)
      end

      # Used in testing, contains hashes mapping 5K race times with the recommended pace-per-km for this run type.
      class GoldenPaces
        def self.fast
          { '14:00': '03:07', '15:00': '03:20', '20:00': '04:21', '25:00': '05:20', '30:00': '06:19', '35:00': '07:16', '40:00': '08:12', '42:00': '08:35' }
        end

        def self.slow
          { '14:00': '03:18', '15:00': '03:31', '20:00': '04:35', '25:00': '05:37', '30:00': '06:38', '35:00': '07:38', '40:00': '08:36', '42:00': '08:59' }
        end
      end
    end
  end
end
