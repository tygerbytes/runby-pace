module Runby
  # Represents a pace consisting of a distance and a time in which that distance was covered
  class Pace
    attr_reader :time, :distance
    def initialize(time, distance = '1K')
      @time = Runby::RunbyTime.parse(time)

      if distance == '1K' then
        @distance = Runby::Distance.new(:km)
      else
        @distance = distance
      end
    end

    def to_s
      "#{time} per #{distance.pluralized_uom}"
    end
  end
end
