require_relative '../../spec_helper'

describe RunbyPace::RunTypes do

  runs = RunbyPace::RunTypes

  describe runs::EasyRun do
    it 'calculates a set of easy run (fast) paces correctly' do
      easy_run = runs::EasyRun.new
      runs::EasyRun::GoldenPaces::fast.each do |five_k, golden_pace|
        calculated_pace_range = easy_run.pace(five_k)
        expect(calculated_pace_range.fast).to be_within_seconds(golden_pace, '00:02')
      end
    end

    it 'calculates a set of easy run (slow) paces correctly' do
      easy_run = runs::EasyRun.new
      runs::EasyRun::GoldenPaces::slow.each do |five_k, golden_pace|
        calculated_pace_range = easy_run.pace(five_k)
        expect(calculated_pace_range.slow).to be_within_seconds(golden_pace, '00:03')
      end
    end

  end

end