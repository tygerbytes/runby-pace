require_relative 'runby_range'

module Runby
  # Represents a range of speeds, from fast to slow.
  class SpeedRange < RunbyRange
    def initialize(fast, slow)
      raise "Invalid fast speed value: #{fast}" unless fast.is_a?(Numeric) || fast.is_a?(Speed)
      raise "Invalid slow speed value: #{slow}" unless slow.is_a?(Numeric) || slow.is_a?(Speed)
      @fast = Runby::Speed.new(fast)
      @slow = Runby::Speed.new(slow)
    end

    def as_pace_range
      Runby::PaceRange.new @fast.as_pace, @slow.as_pace
    end

    def to_s(format: :short)
      if @fast == @slow
        @fast.to_s(format: format)
      else
        fast_multiplier = format('%g', @fast.distance.multiplier.round(2))
        slow_multiplier = format('%g', @slow.distance.multiplier.round(2))
        @fast.to_s(format: format).sub("#{fast_multiplier}", "#{fast_multiplier}-#{slow_multiplier}")
      end
    end
  end
end
