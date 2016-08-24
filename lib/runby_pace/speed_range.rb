require_relative 'runby_range'

module Runby
  # Represents a range of speeds, from fast to slow.
  class SpeedRange < RunbyRange
    def initialize(fast, slow)
      raise 'Invalid speed values' unless fast.is_a?(Numeric) && slow.is_a?(Numeric)
      @fast = fast.round(2)
      @slow = slow.round(2)
    end

    # Create a new speed range from an existing pace range.
    def self.from_pace_range(pace_range)
      fast = Runby::RunMath.convert_pace_to_speed pace_range.fast
      slow = Runby::RunMath.convert_pace_to_speed pace_range.slow
      SpeedRange.new fast, slow
    end
  end
end
