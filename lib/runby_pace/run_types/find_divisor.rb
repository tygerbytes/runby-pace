module RunbyPace

  module RunTypes

    # Currently, to find the radius of the curve in the pace table data for a given run time,
    #   we start with a radius equal to that of the midpoint of the X axis for the data when
    #   plotted on a graph. Then we use a radius divisor for the PaceData for each run type to
    #   dial in the height of the curve. (See RunbyPace::PaceData)
    # This method, #find_divisor, accepts a hash of "golden paces" for a run type along with
    #   the number of seconds of allowable deviation from the golden pace. Then it proceeds
    #   to brute force the divisor.
    # @param [Hash] golden_paces
    # @param [String] allowable_deviation
    # @return [decimal]
    def self.find_divisor(golden_paces, allowable_deviation = '00:01')
      _, first_pace = golden_paces.first
      last_pace = golden_paces[:'42:00']
      viable_divisors = []

      (1.0..5.0).step(0.025) do |candidate_divisor|
        viable_divisor = nil

        golden_paces.each do |five_k, golden_pace|
          five_k_time = RunbyPace::PaceTime.new(five_k.to_s)
          pace_data = RunbyPace::PaceData.new(first_pace, last_pace, candidate_divisor)
          calculated_pace = pace_data.calc(five_k_time)
          if !calculated_pace.almost_equals?(golden_pace, allowable_deviation)
            viable_divisor = nil
            break
          end
          viable_divisor = candidate_divisor
        end

        if viable_divisor != nil
          viable_divisors << viable_divisor
        end
      end

      if viable_divisors.length > 0
        # puts viable_divisors
        midpoint = (viable_divisors.length - 1) / 2
        return viable_divisors[midpoint]
      end
    end

  end
end