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
    end

    # Create a new pace range from an existing speed range.
    def self.from_speed_range(speed_range)
      fast = RunMath.convert_speed_to_pace speed_range.fast
      slow = RunMath.convert_speed_to_pace speed_range.slow
      PaceRange.new fast, slow
    end

    def to_s(format: :long)
      if @fast == @slow
        @fast.to_s(format: format)
      else
        @fast.to_s(format: format).sub("#{@fast.time}", "#{@fast.time}-#{@slow.time}")
      end
    end
  end
end
