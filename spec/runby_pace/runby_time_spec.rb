require_relative '../spec_helper'

describe 'RunbyTime' do
  describe 'RunbyTime initialization and creation' do
    it 'is immutable' do
      time = Runby::RunbyTime.new('6:20')
      expect(time.frozen?).to be true
    end

    it 'parses a time string such as 05:20, where 05 is the number of minutes, and 20 is the number of seconds' do
      time = Runby::RunbyTime.new('05:20')
      expect(time.total_seconds).to eq 320
    end

    it 'parses a time string such as 2:59:01, where 2 is the number of hours, 59 is the number of minutes, and 01 is the seconds' do
      time = Runby::RunbyTime.new('2:59:01')
      expect(time.total_seconds).to eq 10_741
    end

    it 'expects the time to be formatted as \d?\d:\d\d:\d\d or \d\d:\d\d ' do
      expect { Runby::RunbyTime.new('ab:cd') }.to raise_error 'Invalid time format'
    end

    it 'expects the seconds to be between 00 and 59, inclusively' do
      expect { Runby::RunbyTime.new('00:60') }.to raise_error 'Seconds must be less than 60'
    end

    it 'returns a time in minutes if newing up with a number' do
      expect(Runby::RunbyTime.new(5)).to eq '5:00'
    end

    it 'creates a time from numeric seconds' do
      expect(Runby::RunbyTime.from_seconds(61)).to eq '01:01'
    end

    it 'creates a time from numeric minutes' do
      expect(Runby::RunbyTime.from_minutes(0.5)).to eq '00:30'
    end

    it 'creates a time from numeric hours' do
      expect(Runby::RunbyTime.from_hours(2.75)).to eq '2:45:00'
    end

    it 'returns the same (immutable) RunbyTime object if newing up one time from another RunbyTime' do
      pace_time = Runby::RunbyTime.new('03:59')
      newish_time = Runby::RunbyTime.new(pace_time)
      expect(newish_time.object_id).to eq pace_time.object_id
    end

    describe 'Fuzzy string parsing' do
      it 'correctly parses a time string without a leading zero' do
        time = Runby::RunbyTime.new('5:20')
        expect(time.total_seconds).to be 320
      end

      it 'parses a time string without a colon as decimal minutes' do
        time = Runby::RunbyTime.new('5')
        expect(time.total_seconds).to be 300
        expect(time.to_s).to eq '5:00'
      end

      describe 'parses a time string with a decimal separator as decimal minutes' do
        it 'handles . as a decimal separator' do
          time = Runby::RunbyTime.new('5.5')
          expect(time.to_s).to eq '5:30'
        end

        it 'handles , as a decimal separator' do
          time = Runby::RunbyTime.new('5,5')
          expect(time.to_s).to eq '5:30'
        end

        it 'handles a space as a decimal separator' do
          time = Runby::RunbyTime.new('5 5')
          expect(time.to_s).to eq '5:30'
        end
      end

      it 'will not parse a time with minutes greater than 59 when hours are supplied' do
        expect { Runby::RunbyTime.new('1:60:00') }.to raise_error 'Minutes must be less than 60 if hours are supplied'
      end

      it 'will not parse a time with minutes greater than 99 when no hours are supplied' do
        expect { Runby::RunbyTime.new('100') }.to raise_error 'Minutes must be less than 99 if no hours are supplied'
      end

      it 'will parse a time string such as 61:01 as 01:01:01' do
        expect(Runby::RunbyTime.new('61:01')).to eq '01:01:01'
      end

      it 'will not parse a time with hours greater than 23' do
        expect { Runby::RunbyTime.new('24:00:00') }.to raise_error 'Hours must be less than 24'
      end
    end

    describe '#try_parse' do
      it 'parses a valid time string and returns a results hash containing a RunbyTime' do
        results = Runby::RunbyTime.try_parse '05:29'
        expect(results[:time]).to eq '05:29'
        expect(results[:error]).to eq nil
      end

      it 'attempts to parse an invalid time string and returns the error message in the results hash' do
        results = Runby::RunbyTime.try_parse 'INVALID'
        expect(results[:time]).to eq nil
        expect(results[:error]).to eq 'Invalid time format (INVALID)'
      end

      describe '5k sanity checks' do
        it 'returns a warning message if the 5k time < 14:00' do
          results = Runby::RunbyTime.try_parse '13:59', is_five_k: true
          expect(results[:warning]).to eq '5K times of less than 14:00 are unlikely'
        end

        it 'returns a warning message if the 5k time > 42:00' do
          results = Runby::RunbyTime.try_parse '42:01', is_five_k: true
          expect(results[:warning]).to eq '5K times of greater than 42:00 are not fully supported'
        end
      end
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable time format' do
      time = Runby::RunbyTime.new('23:59:59')
      expect(time.to_s).to eq '23:59:59'
    end

    it 'strips any leading zeroes and colons' do
      time = Runby::RunbyTime.new('04:59')
      expect(time.to_s).to eq '4:59'
    end

    it 'strips any leading zeroes, even if hours are supplied' do
      expect(Runby::RunbyTime.new('05:30:01')).to eq '5:30:01'
    end

    it 'shows one leading zero when time is under 1 minute' do
      expect(Runby::RunbyTime.new('00:58').to_s).to eq '0:58'
    end
  end

  describe '#total_seconds' do
    it 'returns the pace time in seconds, represented by an integer' do
      time = Runby::RunbyTime.new('01:01:30')
      expect(time.total_seconds).to eq 3690
    end
  end

  describe '#total_minutes' do
    it 'returns the pace time in minutes ,represented by a floating point numeric value' do
      time = Runby::RunbyTime.new('01:01:30')
      expect(time.total_minutes).to eq 61.5
    end
  end

  describe '#total_hours' do
    it 'returns the pace time in hours, represented by a floating point numeric value' do
      time = Runby::RunbyTime.new('01:30:00')
      expect(time.total_hours).to eq 1.5
    end
  end

  describe 'RunbyTime arithmetic' do
    it 'subtracts (-) one runby time from another' do
      time_a = Runby::RunbyTime.new('01:00:30')
      time_b = Runby::RunbyTime.new('00:31')
      expect(time_a - time_b).to eq '59:59'
    end

    it 'adds (+) one runby time to another' do
      time_a = Runby::RunbyTime.new('1:00:01')
      time_b = Runby::RunbyTime.new('00:59')
      expect(time_a + time_b).to eq '1:01:00'
    end

    it 'multiplies (*) a runby time with a numeric' do
      time = Runby::RunbyTime.new('2:15:59')
      expect(time * 2).to eq '4:31:57'
    end

    it 'divides (/) one runby time with another' do
      dividend = Runby::RunbyTime.new('1:00:00')
      divisor = Runby::RunbyTime.new('5:00')
      quotient = dividend / divisor
      expect(quotient).to eq 12
    end

    it 'divides (/) one runby time with a numeric' do
      time = Runby::RunbyTime.new('1:00:00')
      expect(time / 12).to eq '5:00'
    end
  end

  describe 'RunbyTime equality' do
    it 'should equal another RunbyTime of the same value' do
      time_a = Runby::RunbyTime.new('1:09:59')
      time_b = Runby::RunbyTime.new('1:09:59')
      expect(time_a).to eq time_b
    end

    it 'should equal another string of the same face value' do
      time = Runby::RunbyTime.new('12:15')
      expect(time).to eq '12:15'
    end

    describe '#almost_equals?' do
      it 'should equal another RunbyTime within the given tolerance' do
        time = Runby::RunbyTime.new('1:01:00')
        low_time = Runby::RunbyTime.new('1:00:58')
        high_time = Runby::RunbyTime.new('1:01:02')
        expect(time.almost_equals?(low_time, '00:02')).to be true
        expect(time.almost_equals?(high_time, '00:02')).to be true
      end

      it 'should not equal another RunbyTime outside the given tolerance' do
        time = Runby::RunbyTime.new('01:00')
        too_low_time = Runby::RunbyTime.new('1:00:57')
        too_high_time = Runby::RunbyTime.new('1:01:03')
        expect(time.almost_equals?(too_low_time, '00:02')).to be false
        expect(time.almost_equals?(too_high_time, '00:02')).to be false
      end
    end
  end

  describe 'RunbyTime comparisons' do
    it 'should be greater than another pace time of lesser value' do
      time_a = Runby::RunbyTime.new('00:01')
      time_b = Runby::RunbyTime.new('00:00')
      expect(time_a > time_b).to be true
    end

    it 'should be greater than or equal to another pace time of lesser or equal value' do
      time_a = Runby::RunbyTime.new('00:01')
      time_b = Runby::RunbyTime.new('00:00')
      time_a_clone = Runby::RunbyTime.new(time_a)
      expect(time_a >= time_b).to be true
      expect(time_a >= time_a_clone).to be true
    end

    it 'should be less than another pace time of greater value' do
      time_a = Runby::RunbyTime.new('00:00')
      time_b = Runby::RunbyTime.new('00:01')
      expect(time_a < time_b).to be true
    end

    it 'should be less than or equal to another pace time of greater or equal value' do
      time_a = Runby::RunbyTime.new('00:00')
      time_b = Runby::RunbyTime.new('00:01')
      time_a_clone = Runby::RunbyTime.new(time_a)
      expect(time_a <= time_b).to be true
      expect(time_a <= time_a_clone).to be true
    end

    it 'raises an error if it cannot compare RunbyTime to something' do
      time = Runby::RunbyTime.new(10)
      expect { time == Runby::RunType }.to raise_error 'Unable to compare Runby::RunbyTime to Class(Runby::RunType)'
    end
  end
end
