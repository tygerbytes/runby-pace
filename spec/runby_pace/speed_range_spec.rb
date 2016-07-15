require_relative '../spec_helper'

describe RunbyPace::SpeedRange do
  describe 'Speed range initialization and creation' do
    it 'creates a speed range from two decimals' do
      range = RunbyPace::SpeedRange.new(5.371, 9.129)
      expect(range.fast).to eq 5.37
      expect(range.slow).to eq 9.13
    end

    it 'raises an error if the two values are not numeric' do
      expect{ RunbyPace::SpeedRange.new('ABC', 5.5) }.to raise_error 'Invalid speed values'
      expect{ RunbyPace::SpeedRange.new(5.5, 'ABC') }.to raise_error 'Invalid speed values'
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable range of speed times' do
      range = RunbyPace::SpeedRange.new(5.371, 9.129)
      expect(range.to_s).to eq '5.37-9.13'
    end

    it 'shows only one speed time when fast and slow speeds are equal' do
      range = RunbyPace::SpeedRange.new(5.371, 5.371)
      expect(range.to_s).to eq '5.37'
    end
  end
end
