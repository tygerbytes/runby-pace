require_relative '../../spec_helper'

describe Runby::RunTypes do
  runs = Runby::RunTypes

  describe runs::DistanceRun do
    it 'has the correct description' do
      expect(runs::DistanceRun.new.description).to eq 'Distance Run'
    end

    it 'has a nice explanation' do
      expect(runs::DistanceRun.new.explanation.length).to be > 50
    end

    it 'calculates a set of distance run (fast) paces correctly' do
      distance_run = runs::DistanceRun.new
      runs::DistanceRun::GoldenPaces.fast.each do |five_k, golden_pace|
        calculated_pace_range = distance_run.lookup_pace(five_k)
        expect(calculated_pace_range.fast).to be_within_seconds(golden_pace, '00:02')
      end
    end

    it 'calculates a set of distance run (slow) paces correctly' do
      distance_run = runs::DistanceRun.new
      runs::DistanceRun::GoldenPaces.slow.each do |five_k, golden_pace|
        calculated_pace_range = distance_run.lookup_pace(five_k)
        expect(calculated_pace_range.slow).to be_within_seconds(golden_pace, '00:02')
      end
    end

    it 'calculates the pace in minutes per mile' do
      distance_run = runs::DistanceRun.new
      calculated_pace_range = distance_run.lookup_pace('14:00', :mi)
      expect(calculated_pace_range.fast.to_s(format: :long)).to eq '6:00 per mile'
    end
  end
end
