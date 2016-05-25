module RunbyPace

  module RunTypes

    class LongRun < RunType
      attr_reader :slow_pace_data, :fast_pace_data

      def initialize
        @slow_pace_data = PaceData.new('04:39', '11:53', 1.55)
        @fast_pace_data = PaceData.new('04:00', '10:32', 1.99)
      end

      def pace(five_k_time)
        fast = @fast_pace_data.calc(five_k_time)
        slow = @slow_pace_data.calc(five_k_time)
        PaceRange.new(fast, slow)
      end
    end
  end
end
