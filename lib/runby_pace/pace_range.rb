require_relative 'runby_range'

module RunbyPace
  class PaceRange < RunbyRange
    def initialize(fast, slow)
      @fast = RunbyPace::PaceTime.new(fast)
      @slow = RunbyPace::PaceTime.new(slow)
    end

    def self.from_speed_range(speed_range)
      fast = RunbyPace::RunMath.convert_speed_to_pace speed_range.fast
      slow = RunbyPace::RunMath.convert_speed_to_pace speed_range.slow
      PaceRange.new fast, slow
    end
  end
end
