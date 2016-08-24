require_relative 'runby_range'

module Runby
  # Represents a range of paces, from fast to slow.
  class PaceRange < RunbyRange
    def initialize(fast, slow)
      @fast = Runby::PaceTime.new(fast)
      @slow = Runby::PaceTime.new(slow)
    end

    # Create a new pace range from an existing speed range.
    def self.from_speed_range(speed_range)
      fast = Runby::RunMath.convert_speed_to_pace speed_range.fast
      slow = Runby::RunMath.convert_speed_to_pace speed_range.slow
      PaceRange.new fast, slow
    end
  end
end
