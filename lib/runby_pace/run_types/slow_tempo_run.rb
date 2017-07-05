# frozen_string_literal: true
require_relative 'tempo_run'

module Runby
  module RunTypes
    # The "slow tempo" pace roughly equates to your marathon pace.
    class SlowTempoRun < TempoRun
      def description
        'Slow Tempo Run'
      end

      def explanation
        'The slow tempo run is an interval workout of 20-40 minutes per repetition. The pace roughly corresponds to that of your marathon race pace.'
      end

      def lookup_pace(five_k_time, distance_units = :km)
        slow = @slow_pace_calculator.calc(five_k_time, distance_units)
        PaceRange.new(slow, slow)
      end
    end
  end
end
