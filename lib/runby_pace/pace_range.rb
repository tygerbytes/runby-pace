# frozen_string_literal: true

require_relative 'runby_range'

module Runby
  # Represents a range of paces, from fast to slow.
  class PaceRange < RunbyRange
    def initialize(fast, slow, distance_units = :km)
      if fast.is_a?(Pace) && slow.is_a?(Pace)
        @fast = fast
        @slow = slow
      else
        # Hopefully 'fast' and 'slow' are parseable as a RunbyTime
        distance = Distance.new distance_units, 1
        @fast = Pace.new(fast, distance)
        @slow = Pace.new(slow, distance)
      end
      freeze
    end

    def as_speed_range
      SpeedRange.new @fast.as_speed, @slow.as_speed
    end

    def to_s(format: :short)
      if @fast == @slow
        @fast.to_s(format: format)
      else
        @fast.to_s(format: format).sub("#{@fast.time}", "#{@fast.time}-#{@slow.time}")
      end
    end
  end
end
