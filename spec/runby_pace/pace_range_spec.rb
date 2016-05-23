require_relative '../spec_helper'

describe RunbyPace::PaceRange do
  describe 'Pace range initialization and creation' do
    it 'creates a range from two pace time strings' do
      range = RunbyPace::PaceRange.new('10:00', '20:00')
      expect(range.fast).to eq '10:00'
      expect(range.slow).to eq '20:00'
    end
  end


end
