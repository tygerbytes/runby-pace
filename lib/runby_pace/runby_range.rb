module RunbyPace

  class RunbyRange
    attr_reader :fast, :slow

    def initialize
      @fast = nil
      @slow = nil
      raise 'RunbyRange is a base class for PaceRange and SpeedRange. Instantiate one of them instead.'
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