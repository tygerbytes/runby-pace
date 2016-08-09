require_relative 'tempo_run'

module RunbyPace
  module RunTypes
    class SlowTempoRun < TempoRun
      def description
        'Slow Tempo Run'
      end

      def pace(five_k_time, distance_units = :km)
        slow = @slow_pace_data.calc(five_k_time, distance_units)
        PaceRange.new(slow, slow)
      end
    end
  end
end
