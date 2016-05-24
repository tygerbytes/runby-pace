module RunbyPace

  class PaceData

    # The number of data points plotted on our line of 5K times.
    #  We take 5K times from 14:00 to 42:00 with a sample rate
    #  of 30 seconds, and out pops 57.
    DATA_POINTS_COUNT = 57

    # The fastest pace within the run type data set.
    #  Given a personal record of 14 minutes for a 5K race,
    #  this is the prescribed pace for this run type.
    attr_reader :fastest_pace_km

    # The slowest pace for the run type data set.
    #  Given a personal record of 42 minutes for a 5K race,
    #  this is the prescribed pace for this run type.
    attr_reader :slowest_pace_km

    # In the pace tables I consulted, the paces did not progress
    #  linearly from fastest to slowest when plotted on a graph.
    #  In most cases there was a noticeable curve with its highest
    #  point located near the line's midpoint.
    attr_reader :midpoint_radius_divisor

    def initialize(fastest_pace_km, slowest_pace_km, midpoint_radius_divisor)
      @fastest_pace_km = RunbyPace::PaceTime.new(fastest_pace_km)
      @slowest_pace_km = RunbyPace::PaceTime.new(slowest_pace_km)
      @midpoint_radius_divisor = midpoint_radius_divisor
    end

    # Calculate the slope of the line between the fastest and slowest paces
    def slope
      (@slowest_pace_km.total_minutes - @fastest_pace_km.total_minutes) / (DATA_POINTS_COUNT - 1)
    end
  end
end
