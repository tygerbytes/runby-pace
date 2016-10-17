module Runby
  # Extend RunTypes with additional behavior. (See comments for details)
  module RunTypes
    # Currently, to find the radius of the curve in the pace table data for a given run time,
    #   we start with a radius equal to that of the midpoint of the X axis for the data when
    #   plotted on a graph. Then we use a radius divisor for the PaceCalculator for each run type to
    #   dial in the height of the curve. (See Runby::PaceCalculator)
    # This method, #find_divisor, accepts a hash of "golden paces" for a run type along with
    #   the number of seconds of allowable deviation from the golden pace. Then it proceeds
    #   to brute force the divisor.
    # @param [GoldenPaceSet] golden_pace_set
    # @param [String] allowable_deviation
    # @return [decimal]
    def self.find_divisor(golden_pace_set, allowable_deviation = '00:01')
      viable_divisors = []

      (1.0..5.0).step(0.025) do |candidate_divisor|
        viable_divisor = nil

        golden_pace_set.each do |five_k, golden_pace|
          five_k_time = Runby::RunbyTime.new(five_k.to_s)
          pace_data = Runby::PaceCalculator.new(golden_pace_set, candidate_divisor)
          calculated_pace = pace_data.calc(five_k_time)
          unless calculated_pace.time.almost_equals?(golden_pace.time, allowable_deviation)
            viable_divisor = nil
            break
          end
          viable_divisor = candidate_divisor
        end

        viable_divisors << viable_divisor unless viable_divisor.nil?
      end

      unless viable_divisors.empty?
        # puts viable_divisors
        midpoint = (viable_divisors.length - 1) / 2
        return viable_divisors[midpoint]
      end
    end
  end
end
