require_relative 'tempo_run'

module RunbyPace

  module RunTypes

    class FastTempoRun < TempoRun
      def description
        'Fast Tempo Run'
      end

      def pace(five_k_time, distance_units = :km)
        fast = @fast_pace_data.calc(five_k_time, distance_units)
        PaceRange.new(fast, fast)
      end
    end
  end
end
