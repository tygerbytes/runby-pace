require_relative '../spec_helper'

describe 'PaceTime' do

  describe 'PaceTime initialization and creation' do
    it 'parses a time string such as 05:20, where 05 is the number of minutes, and 20 is the number of seconds' do
      time = RunbyPace::PaceTime.new('05:20')
      expect(time.total_seconds).to be 320
    end

    it 'expects the time to be formatted as (-)?\d\d:\d\d ' do
      # The '-' is an optional negative sign
      expect { RunbyPace::PaceTime.new('ab:cd') }.to raise_error 'Invalid time format'
    end

    it 'expects the seconds to be between 00 and 59, inclusively' do
      expect { RunbyPace::PaceTime.new('00:60') }.to raise_error 'Seconds must be less than 60'
    end

    it 'creates a time from numeric seconds' do
      expect(RunbyPace::PaceTime.from_seconds(61)).to eq '01:01'
    end

    it 'creates a time from another pace time' do
      pace_time = RunbyPace::PaceTime.new('03:59')
      cloned_time = RunbyPace::PaceTime.new(pace_time)
      expect(cloned_time).to eq pace_time
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable time format' do
      time = RunbyPace::PaceTime.new('99:59')
      expect(time.to_s).to eq '99:59'
    end
  end

  describe 'PaceTime arithmetic' do
    it 'subtracts one runby time from another' do
      time_a = RunbyPace::PaceTime.new('01:30')
      time_b = RunbyPace::PaceTime.new('00:31')
      expect(time_a - time_b).to eq '00:59'
    end

    it 'adds one runby time to another' do
      time_a = RunbyPace::PaceTime.new('00:01')
      time_b = RunbyPace::PaceTime.new('00:59')
      expect(time_a + time_b).to eq '01:00'
    end
  end

  describe 'PaceTime equality' do
    it 'should equal another PaceTime of the same value' do
      time_a = RunbyPace::PaceTime.new('09:59')
      time_b = RunbyPace::PaceTime.new('09:59')
      expect(time_a).to eq time_b
    end

    it 'should equal another string of the same face value' do
      time = RunbyPace::PaceTime.new('12:15')
      expect(time).to eq '12:15'
    end
  end

  describe 'PaceTime comparisons' do
    it 'should be greater than another pace time of lesser value' do
      time_a = RunbyPace::PaceTime.new('00:01')
      time_b = RunbyPace::PaceTime.new('00:00')
      expect(time_a > time_b).to be true
    end

    it 'should be greater than or equal to another pace time of lesser or equal value' do
      time_a = RunbyPace::PaceTime.new('00:01')
      time_b = RunbyPace::PaceTime.new('00:00')
      expect(time_a >= time_b).to be true
      expect(time_a >= time_a).to be true
    end

    it 'should be less than another pace time of greater value' do
      time_a = RunbyPace::PaceTime.new('00:00')
      time_b = RunbyPace::PaceTime.new('00:01')
      expect(time_a < time_b).to be true
    end

    it 'should be less than or equal to another pace time of greater or equal value' do
      time_a = RunbyPace::PaceTime.new('00:00')
      time_b = RunbyPace::PaceTime.new('00:01')
      expect(time_a <= time_b).to be true
      expect(time_a <= time_a).to be true
    end
  end


end