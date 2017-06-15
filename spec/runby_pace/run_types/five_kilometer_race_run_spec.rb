require_relative '../../spec_helper'

describe Runby::RunTypes do
  runs = Runby::RunTypes

  describe runs::FiveKilometerRaceRun do
    it 'has the correct description' do
      expect(runs::FiveKilometerRaceRun.new.description).to start_with'5K Race Pace'
    end

    it 'has a nice explanation' do
      expect(runs::FiveKilometerRaceRun.new.explanation.length).to be > 50
    end

    it 'calculates the 5K race pace correctly' do
      five_k_run = runs::FiveKilometerRaceRun.new
      expect(five_k_run.lookup_pace('20:00').slow.to_s(format: :long)).to eq '4:00 per kilometer'
    end

    it 'calculates the pace in minutes per mile' do
      five_k_run = runs::FiveKilometerRaceRun.new
      expect(five_k_run.lookup_pace('20:00', :mi).slow.to_s(format: :long)).to eq '6:26 per mile'
    end
  end
end
