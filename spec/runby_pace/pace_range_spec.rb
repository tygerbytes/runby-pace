require_relative '../spec_helper'

describe Runby::PaceRange do
  describe 'Pace range initialization and creation' do
    it 'creates a range from two pace time strings' do
      range = Runby::PaceRange.new('10:00', '20:00')
      expect(range.fast).to eq '10:00'
      expect(range.slow).to eq '20:00'
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable range of pace times' do
      range = Runby::PaceRange.new('10:00', '10:59')
      expect(range.to_s(format: :long)).to eq '10:00-10:59 per kilometer'
    end

    it 'shows only one pace time when fast and slow paces are equal' do
      range = Runby::PaceRange.new('09:59', '09:59')
      expect(range.to_s(format: :long)).to eq '9:59 per kilometer'
    end

    it 'shows the full pace description if the format is :long' do
      range = Runby::PaceRange.new('09:59', '10:59')
      expect(range.to_s(format: :long)).to eq '9:59-10:59 per kilometer'
    end

    it 'shows an abbreviated pace description if the format is :short' do
      range = Runby::PaceRange.new('09:59', '10:59')
      expect(range.to_s(format: :short)).to eq '9:59-10:59 p/km'
    end
  end

  describe '#as_speed_range' do
    it 'creates a new speed range from this pace range' do
      pace_range = Runby::PaceRange.new('10:00', '12:00')
      speed_range = pace_range.as_speed_range
      expect(speed_range.fast.to_s).to eq '6 km/ph'
      expect(speed_range.slow.to_s).to eq '5 km/ph'
    end
  end
end
