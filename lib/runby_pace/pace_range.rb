module RunbyPace

  class PaceRange
    attr_reader :fast, :slow

    def initialize(slow, fast)
      @fast = RunbyPace::PaceTime.new(slow)
      @slow = RunbyPace::PaceTime.new(fast)
    end
  end
end