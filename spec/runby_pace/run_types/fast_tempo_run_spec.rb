require_relative '../../spec_helper'

describe RunbyPace::RunTypes do

  runs = RunbyPace::RunTypes

  describe runs::FastTempoRun do
    it 'calculates a set of fast tempo run paces correctly' do
      fast_tempo_run = runs::FastTempoRun.new
      runs::FastTempoRun::GoldenPaces::fast.each do |five_k, golden_pace|
        calculated_pace_range = fast_tempo_run.pace(five_k)
        expect(calculated_pace_range.fast).to be_within_seconds(golden_pace, '00:01')
      end
    end

    it 'calculates the pace in minutes per mile' do
      fast_tempo_run = runs::FastTempoRun.new
      calculated_pace_range = fast_tempo_run.pace('14:00', :mi)
      expect(calculated_pace_range.fast).to eq '05:01'
    end

  end
end
