require_relative '../../spec_helper'

describe Runby::RunTypes do
  runs = Runby::RunTypes

  describe runs::MileRaceRun do
    it 'has the correct description' do
      expect(runs::MileRaceRun.new.description).to start_with 'Mile Race Pace'
    end

    it 'has a nice explanation' do
      expect(runs::MileRaceRun.new.explanation.length).to be > 50
    end

    it 'calculates the mile race pace correctly' do
      five_k_run = runs::MileRaceRun.new
      expect(five_k_run.lookup_pace('20:00').slow.to_s(format: :long)).to eq '3:43 per kilometer'
    end

    it 'calculates the pace in minutes per mile' do
      five_k_run = runs::MileRaceRun.new
      expect(five_k_run.lookup_pace('20:00', :mi).slow.to_s(format: :long)).to eq '6:00 per mile'
    end
  end
end
