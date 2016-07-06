require_relative '../../spec_helper'

describe RunbyPace::RunTypes do

  runs = RunbyPace::RunTypes

  describe runs::LongRun do
    it 'calculates a set of long run (fast) paces correctly' do
      long_run = runs::LongRun.new
      runs::LongRun::GoldenPaces::fast.each do |five_k, golden_pace|
        calculated_pace_range = long_run.pace(five_k)
        expect(calculated_pace_range.fast).to be_within_seconds(golden_pace, '00:02')
      end
    end

    it 'calculates a set of long run (slow) paces correctly' do
      long_run = runs::LongRun.new
      runs::LongRun::GoldenPaces::slow.each do |five_k, golden_pace|
        calculated_pace_range = long_run.pace(five_k)
        expect(calculated_pace_range.slow).to be_within_seconds(golden_pace, '00:03')
      end
    end

    it 'calculates the pace in minutes per mile' do
      long_run = runs::LongRun.new
      calculated_pace_range = long_run.pace('14:00', :mi)
      expect(calculated_pace_range.fast).to eq '06:27'
    end

  end

end
