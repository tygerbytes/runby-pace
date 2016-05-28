module RunbyPace

  module RunTypes

    class EasyRun < RunType
      attr_reader :slow_pace_data, :fast_pace_data

      def initialize
        @fast_pace_data = PaceData.new(GoldenPaces::fast[:'14:00'], GoldenPaces::fast[:'42:00'], 1.99)
        @slow_pace_data = PaceData.new(GoldenPaces::slow[:'14:00'], GoldenPaces::slow[:'42:00'], 1.35)
      end

      def pace(five_k_time)
        fast = @fast_pace_data.calc(five_k_time)
        slow = @slow_pace_data.calc(five_k_time)
        PaceRange.new(fast, slow)
      end

      class GoldenPaces
        def self.fast
          { '14:00': '04:17', '15:00': '04:33', '20:00': '05:53', '25:00': '07:09', '30:00': '08:23', '35:00': '09:33', '40:00': '10:41', '42:00': '11:08'}
        end
        def self.slow
          { '14:00': '05:01', '15:00': '05:20', '20:00': '06:51', '25:00': '08:17', '30:00': '09:38', '35:00': '10:56', '40:00': '12:10', '42:00': '12:39'}
        end
      end
    end
  end
end