require_relative '../../spec_helper'

describe RunbyPace::RunTypes do

  runs = RunbyPace::RunTypes

  describe runs::DistanceRun do
    it 'calculates a set of distance run (fast) paces correctly' do
      distance_run = runs::DistanceRun.new
      runs::DistanceRun::GoldenPaces::fast.each do |five_k, golden_pace|
        calculated_pace_range = distance_run.pace(five_k)
        expect(calculated_pace_range.fast).to be_within_seconds(golden_pace, '00:02')
      end
    end

    it 'calculates a set of distance run (slow) paces correctly' do
      distance_run = runs::DistanceRun.new
      runs::DistanceRun::GoldenPaces::slow.each do |five_k, golden_pace|
        calculated_pace_range = distance_run.pace(five_k)
        expect(calculated_pace_range.slow).to be_within_seconds(golden_pace, '00:02')
      end
    end

  end

end
