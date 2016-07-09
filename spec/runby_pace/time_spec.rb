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

    it 'creates a time from numeric minutes' do
      expect(RunbyPace::PaceTime.from_minutes(0.5)).to eq '00:30'
    end

    it 'creates a time from another pace time' do
      pace_time = RunbyPace::PaceTime.new('03:59')
      cloned_time = RunbyPace::PaceTime.new(pace_time)
      expect(cloned_time).to eq pace_time
    end

    describe 'Fuzzy string parsing' do
      it 'correctly parses a time string without a leading zero' do
        time = RunbyPace::PaceTime.new('5:20')
        expect(time.total_seconds).to be 320
      end

      it 'parses a time string without a colon as decimal minutes' do
        time = RunbyPace::PaceTime.new('5')
        expect(time.total_seconds).to be 300
        expect(time.to_s).to eq '05:00'
      end

      describe 'parses a time string with a decimal separator as decimal minutes' do
        it 'handles . as a decimal separator' do
          time = RunbyPace::PaceTime.new('5.5')
          expect(time.to_s).to eq '05:30'
        end

        it 'handles , as a decimal separator' do
          time = RunbyPace::PaceTime.new('5,5')
          expect(time.to_s).to eq '05:30'
        end

        it 'handles a space as a decimal separator' do
          time = RunbyPace::PaceTime.new('5 5')
          expect(time.to_s).to eq '05:30'
        end
      end

      it 'will not parse a time greater than 99 minutes' do
        expect { RunbyPace::PaceTime.new('100') }.to raise_error 'Minutes must be less than 100'
      end
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable time format' do
      time = RunbyPace::PaceTime.new('99:59')
      expect(time.to_s).to eq '99:59'
    end
  end

  describe '#total_seconds' do
    it 'returns the pace time in seconds, represented by an integer' do
      time = RunbyPace::PaceTime.new('01:30')
      expect(time.total_seconds).to eq 90
    end
  end

  describe '#total_minutes' do
    it 'returns the pace time in minutes ,represented by a floating point numeric value' do
      time = RunbyPace::PaceTime.new('01:30')
      expect(time.total_minutes).to eq 1.5
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

    describe '#almost_equals?' do
      it 'should equal another PaceTime within the given tolerance' do
        time = RunbyPace::PaceTime.new('01:00')
        low_time = RunbyPace::PaceTime.new('00:58')
        high_time = RunbyPace::PaceTime.new('01:02')
        expect(time.almost_equals?(low_time, '00:02')).to be true
        expect(time.almost_equals?(high_time, '00:02')).to be true
      end

      it 'should not equal another PaceTime outside the given tolerance' do
        time = RunbyPace::PaceTime.new('01:00')
        too_low_time = RunbyPace::PaceTime.new('00:57')
        too_high_time = RunbyPace::PaceTime.new('01:03')
        expect(time.almost_equals?(too_low_time, '00:02')).to be false
        expect(time.almost_equals?(too_high_time, '00:02')).to be false
      end
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