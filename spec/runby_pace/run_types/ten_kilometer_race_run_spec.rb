require_relative '../../spec_helper'

describe Runby::RunTypes do
  runs = Runby::RunTypes

  describe runs::TenKilometerRaceRun do
    it 'has the correct description' do
      expect(runs::TenKilometerRaceRun.new.description).to start_with'10K Race Pace'
    end

    it 'has a nice explanation' do
      expect(runs::TenKilometerRaceRun.new.explanation.length).to be > 50
    end

    it 'calculates the 10K race pace correctly' do
      ten_k_run = runs::TenKilometerRaceRun.new
      expect(ten_k_run.lookup_pace('20:00').slow.to_s(format: :long)).to eq '4:10 per kilometer'
    end

    it 'calculates the pace in minutes per mile' do
      ten_k_run = runs::TenKilometerRaceRun.new
      expect(ten_k_run.lookup_pace('20:00', :mi).slow.to_s(format: :long)).to eq '6:42 per mile'
    end
  end
end
