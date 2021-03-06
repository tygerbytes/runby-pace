# frozen_string_literal: true

module Runby
  # Encapsulates the algorithms used to calculate target paces.
  class PaceCalculator
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

    def initialize(golden_pace_set, midpoint_radius_divisor)
      @fastest_pace_km = golden_pace_set.fastest
      @slowest_pace_km = golden_pace_set.slowest
      @midpoint_radius_divisor = midpoint_radius_divisor
    end

    # Calculate the slope of the line between the fastest and slowest paces
    def slope
      (@slowest_pace_km.time.total_minutes - @fastest_pace_km.time.total_minutes) / (DATA_POINTS_COUNT - 1)
    end

    # Calculate the prescribed pace for the given 5K time
    # @return [Pace]
    def calc(five_k_time, distance_units = :km)
      five_k_time = Runby.sanitize(five_k_time).as(RunbyTime)
      distance_units = Runby.sanitize(distance_units).as(DistanceUnit)

      minutes_per_unit = calculate_minutes_per_unit(distance_units, five_k_time)
      build_pace minutes_per_unit, distance_units
    end

    private

    def build_pace(minutes_per_unit, distance_units)
      time = RunbyTime.from_minutes(minutes_per_unit)
      distance = Distance.new distance_units, 1
      Pace.new time, distance
    end

    def calculate_minutes_per_unit(distance_units, five_k_time)
      x2 = ((five_k_time.total_minutes * 2) - (MIDPOINT_X - 1)) - 1
      minutes_per_km = slope * x2 + @fastest_pace_km.time.total_minutes + curve_minutes(x2)
      minutes_per_km * distance_units.conversion_factor
    end

    # Since the paces for each 5K time do not progress in a straight line
    #  when plotted on a graph, but rather a curve with its highest point near
    #  the center, we must add some seconds to the calculated time depending on
    #  where we are on the line.
    # Paces near the start and end of the line need little to no time added,
    #  whereas paces near the middle need the most time added.
    # The default curve radius is the same as the midpoint of the X axis,
    #  forming a circle. Use #midpoint_radius_divisor to reduce it's size.
    def curve_minutes(x_axis)
      return 0 if @midpoint_radius_divisor.zero?
      midpoint_reduction = x_axis
      midpoint = MIDPOINT_X
      if midpoint_reduction > midpoint
        midpoint_reduction = midpoint - (midpoint_reduction - midpoint)
        midpoint_reduction = 0 if midpoint_reduction.negative?
      end
      # TODO: Use an actual curve instead of a triangle to calculate the number of minutes to add.
      midpoint_reduction / @midpoint_radius_divisor / 60
    end
  end
end
