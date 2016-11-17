require_relative '../../spec_helper'

describe Runby::RunTypes do
  runs = Runby::RunTypes

  describe runs::EasyRun do
    it 'has the correct description' do
      expect(runs::EasyRun.new.description).to eq 'Easy Run'
    end

    it 'calculates a set of easy run (fast) paces correctly' do
      easy_run = runs::EasyRun.new
      runs::EasyRun::GoldenPaces.fast.each do |five_k, golden_pace|
        calculated_pace_range = easy_run.lookup_pace(five_k)
        expect(calculated_pace_range.fast).to be_within_seconds(golden_pace, '00:02')
      end
    end

    it 'calculates a set of easy run (slow) paces correctly' do
      easy_run = runs::EasyRun.new
      runs::EasyRun::GoldenPaces.slow.each do |five_k, golden_pace|
        calculated_pace_range = easy_run.lookup_pace(five_k)
        expect(calculated_pace_range.slow).to be_within_seconds(golden_pace, '00:03')
      end
    end

    it 'calculates the pace in minutes per mile' do
      easy_run = runs::EasyRun.new
      calculated_pace_range = easy_run.lookup_pace('14:00', :mi)
      expect(calculated_pace_range.fast.to_s(format: :long)).to eq '6:53 per mile'
    end
  end
end
