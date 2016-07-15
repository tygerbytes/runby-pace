require_relative 'runby_range'

module RunbyPace

  class PaceRange < RunbyRange
    def initialize(fast, slow)
      @fast = RunbyPace::PaceTime.new(fast)
      @slow = RunbyPace::PaceTime.new(slow)
    end
  end
end