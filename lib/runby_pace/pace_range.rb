module RunbyPace

  class PaceRange
    attr_reader :fast, :slow

    def initialize(fast, slow)
      @fast = RunbyPace::PaceTime.new(fast)
      @slow = RunbyPace::PaceTime.new(slow)
    end

    def to_s
      "#{@fast}-#{@slow}"
    end
  end
end