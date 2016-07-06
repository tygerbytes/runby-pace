module RunbyPace

  module RunTypes

    class LongRun < RunType
      attr_reader :slow_pace_data, :fast_pace_data

      def description
        'Long Run'
      end

      def initialize
        @fast_pace_data = PaceData.new(GoldenPaces::fast[:'14:00'], GoldenPaces::fast[:'42:00'], 2.125)
        @slow_pace_data = PaceData.new(GoldenPaces::slow[:'14:00'], GoldenPaces::slow[:'42:00'], 1.55)
      end

      def pace(five_k_time, distance_units = :km)
        fast = @fast_pace_data.calc(five_k_time, distance_units)
        slow = @slow_pace_data.calc(five_k_time, distance_units)
        PaceRange.new(fast, slow)
      end

      class GoldenPaces
        def self.fast
          { '14:00': '04:00', '15:00': '04:16', '20:00': '05:31', '25:00': '06:44', '30:00': '07:54', '35:00':'09:01', '40:00':'10:07', '42:00':'10:32'}
        end
        def self.slow
          { '14:00': '04:39', '15:00': '04:57', '20:00': '06:22', '25:00': '07:43', '30:00': '09:00', '35:00':'10:15', '40:00':'11:26', '42:00':'11:53'}
        end
      end
    end
  end
end
