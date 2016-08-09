require_relative '../../spec_helper'

describe RunbyPace::RunTypes do
  runs = RunbyPace::RunTypes

  describe runs::FastTempoRun do
    it 'calculates a set of fast tempo run paces correctly' do
      fast_tempo_run = runs::FastTempoRun.new
      runs::FastTempoRun::GoldenPaces.fast.each do |five_k, golden_pace|
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

  describe runs::SlowTempoRun do
    it 'calculates a set of slow tempo run paces correctly' do
      slow_tempo_run = runs::SlowTempoRun.new
      runs::SlowTempoRun::GoldenPaces.slow.each do |five_k, golden_pace|
        calculated_pace_range = slow_tempo_run.pace(five_k)
        expect(calculated_pace_range.slow).to be_within_seconds(golden_pace, '00:01')
      end
    end

    it 'calculates the pace in minutes per mile' do
      slow_tempo_run = runs::SlowTempoRun.new
      calculated_pace_range = slow_tempo_run.pace('14:00', :mi)
      expect(calculated_pace_range.slow).to eq '05:19'
    end
  end

  describe runs::TempoRun do
    it 'combines the fast and slow tempo runs into one run type' do
      tempo_run = runs::TempoRun.new
      calculated_pace_range = tempo_run.pace('14:00')
      expect(calculated_pace_range.fast).to eq '03:07'
      expect(calculated_pace_range.slow).to eq '03:18'
    end
  end
end
