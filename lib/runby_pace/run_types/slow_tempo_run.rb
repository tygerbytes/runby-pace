module RunbyPace

  module RunTypes

    class SlowTempoRun < RunType
      attr_reader :slow_pace_data, :slow_pace_data

      def description
        'Slow Tempo Run'
      end

      def initialize
        @slow_pace_data = PaceData.new(GoldenPaces::slow[:'14:00'], GoldenPaces::slow[:'42:00'], 3.725)
        @slow_pace_data = @slow_pace_data
      end

      def pace(five_k_time, distance_units = :km)
        slow = @slow_pace_data.calc(five_k_time, distance_units)
        slow = slow
        PaceRange.new(slow, slow)
      end

      class GoldenPaces
        def self.slow
          { '14:00': '03:18', '15:00': '03:31', '20:00': '04:35', '25:00': '05:37', '30:00': '06:38', '35:00':'07:38', '40:00':'08:36', '42:00':'08:59'}
        end
      end
    end
  end
end
