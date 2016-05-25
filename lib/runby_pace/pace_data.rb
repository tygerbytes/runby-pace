module RunbyPace

  class PaceData

    # The number of data points plotted on our line of 5K times.
    #  We take 5K times from 14:00 to 42:00 with a sample rate
    #  of 30 seconds, and out pops 57.
    DATA_POINTS_COUNT = 57

    # The midpoint along the X axis of our pace data "graph"
    MIDPOINT_X = 28

    # The fastest pace within the run type data set.
    #  Given a personal record of 14 minutes for a 5K race,
    #  this is the prescribed pace for this run type.
    attr_reader :fastest_pace_km

    # The slowest pace for the run type data set.
    #  Given a personal record of 42 minutes for a 5K race,
    #  this is the prescribed pace for this run type.
    attr_reader :slowest_pace_km

    # For maximum flexibility, we assume the radius of the curve
    #  of the pace data to be equal to the X axis midpoint, a perfect circle.
    #  Use the midpoint_radius_divisor to reduce the height of the curve
    #  until it matches that of the data. (See #curve_minutes)
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

    private

    # Since the paces for each 5K time do not progress in a straight line
    #  when plotted on a graph, but rather a curve with its highest point near
    #  the center, we must add some seconds to the calculated time depending on
    #  where we are on the line.
    # Paces near the start and end of the line need little to no time added,
    #  whereas paces near the middle need the most time added.
    # The default curve radius is the same as the midpoint of the X axis,
    #  forming a circle. Use #midpoint_radius_divisor to reduce it's size.
    def curve_minutes(x_axis)
      return 0 if @midpoint_radius_divisor == 0
      midpoint_reduction = x_axis
      midpoint = MIDPOINT_X
      if midpoint_reduction > midpoint
        midpoint_reduction = midpoint - (midpoint_reduction - midpoint)
        midpoint_reduction = 0 if midpoint_reduction < 0
      end
      midpoint_reduction / @midpoint_radius_divisor / 60
    end
  end
end