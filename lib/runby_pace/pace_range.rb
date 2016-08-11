require_relative 'runby_range'

module RunbyPace
  # Represents a range of paces, from fast to slow.
  class PaceRange < RunbyRange
    def initialize(fast, slow)
      @fast = RunbyPace::PaceTime.new(fast)
      @slow = RunbyPace::PaceTime.new(slow)
    end

    # Create a new pace range from an existing speed range.
    def self.from_speed_range(speed_range)
      fast = RunbyPace::RunMath.convert_speed_to_pace speed_range.fast
      slow = RunbyPace::RunMath.convert_speed_to_pace speed_range.slow
      PaceRange.new fast, slow
    end
  end
end
