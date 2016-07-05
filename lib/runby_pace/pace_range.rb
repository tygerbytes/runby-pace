module RunbyPace

  class PaceRange
    attr_reader :fast, :slow

    def initialize(fast, slow)
      @fast = RunbyPace::PaceTime.new(fast)
      @slow = RunbyPace::PaceTime.new(slow)
    end

    def to_s
      if @fast == @slow
        "#{@fast}"
      else
        "#{@fast}-#{@slow}"
      end
    end
  end
end