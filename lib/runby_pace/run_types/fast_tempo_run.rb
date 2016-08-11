require_relative 'tempo_run'

module RunbyPace
  module RunTypes
    # The "fast tempo" pace roughly equates to your half-marathon pace.
    #  It's a pace you could maintain for about an hour, if pressed.
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
