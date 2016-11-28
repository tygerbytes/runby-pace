require_relative '../spec_helper'

describe Runby::Pace do
  it 'represents a "pace" such as 4:59 per mile' do
    distance = Runby::Distance.new(:mi)
    pace = Runby::Pace.new('4:59', distance)
    expect(pace.to_s(format: :long)).to eq '4:59 per mile'
  end

  it 'encapsulates a distance (in units) and the time in which it was performed' do
    pace = Runby::Pace.new('20:00', '5K')
    expect(pace.time).to eq '20:00'
    expect(pace.distance.to_s(format: :long)).to eq '5 kilometers'
  end

  describe '#meters_per_minute' do
    it 'returns the number of meters ran in one minute' do
      pace = Runby::Pace.new('10:00', '1 km')
      expect(pace.meters_per_minute).to eq 100
    end

    it 'returns the meters per minute, even for non-metric distance units' do
      pace = Runby::Pace.new('10:00', '1 mi')
      expect(pace.meters_per_minute).to be_within(0.01).of 160.93
    end
  end

  describe 'Pace initialization' do
    it 'is initialized by a time and a distance' do
      time = Runby::RunbyTime.new('11:01')
      distance = Runby::Distance.new(:km, 3)
      pace = Runby::Pace.new(time, distance)
      expect(pace.distance.to_s(format: :long)).to eq '3 kilometers'
      expect(pace.time).to eq '11:01'
    end

    describe 'Time parameter' do
      it 'may be an instance of RunbyTime' do
        time = Runby::RunbyTime.new('3:30')
        pace = Runby::Pace.new(time)
        expect(pace.time.class).to eq Runby::RunbyTime
      end

      it 'may be a time string like "10:30", parsable by RunbyTime' do
        pace = Runby::Pace.new('10:30')
        expect(pace.time.class).to eq Runby::RunbyTime
        expect(pace.time).to eq '10:30'
      end

      it 'may also be a Pace, in which case the Pace is cloned' do
        pace = Runby::Pace.new('10:30')
        cloned_pace = Runby::Pace.new(pace)
        expect(pace).to_not be cloned_pace
        expect(cloned_pace.time == pace.time)
        expect(cloned_pace.distance == pace.distance)
      end
    end

    describe 'Distance parameter' do
      it 'defaults to 1 kilometer if not provided' do
        pace = Runby::Pace.new('59:59')
        expect(pace.distance.uom.symbol).to eq :km
        expect(pace.distance.multiplier).to eq 1
      end

      it 'may be an instance of Runby::Distance' do
        distance = Runby::Distance.new(:km, 50)
        pace = Runby::Pace.new('59:00', distance)
        expect(pace.distance.class).to eq Runby::Distance
      end

      it 'may be a string representing a valid distance' do
        pace = Runby::Pace.new('30:00', '5K')
        expect(pace.distance.to_s(format: :long)).to eq '5 kilometers'
      end
    end

    describe '#parse' do
      it 'parses a string as a pace and returns a new Pace' do
        pace = Runby::Pace.parse '10:00 p/mi'
        expect(pace.time).to eq '10:00'
        expect(pace.distance).to eq '1 mile'
      end

      it 'raises an error if it cannot parse the pace' do
        expect { Runby::Pace.parse '5' }.to raise_error 'Invalid pace format (5)'
      end
    end

    describe '#try_parse' do
      it 'parses a string containing a valid pace and returns a results hash containing a Pace' do
        results = Runby::Pace.try_parse '10:00 per mile'
        expect(results[:pace].time).to eq '10:00'
        expect(results[:pace].distance).to eq '1 mile'
        expect(results[:error]).to eq nil
      end

      it 'attempts to parse a string containing an invalid pace and returns the error message in the results hash' do
        results = Runby::Pace.try_parse 'INVALID'
        expect(results[:pace]).to eq nil
        expect(results[:error]).to eq 'Invalid pace format (INVALID)'
      end
    end
  end

  describe 'Pace arithmetic' do
    it 'subtracts one pace from another' do
      pace_a = Runby::Pace.new('01:30')
      pace_b = Runby::Pace.new('00:31')
      expect(pace_a - pace_b).to eq '00:59'
    end

    it 'subtracts a RunbyTime from a Pace' do
      pace = Runby::Pace.new('01:30')
      time = Runby::RunbyTime.new('00:31')
      difference = pace - time
      expect(difference.class).to eq Runby::Pace
      expect(difference).to eq '00:59'
    end

    it 'adds one pace to another' do
      pace_a = Runby::Pace.new('00:01')
      pace_b = Runby::Pace.new('00:59')
      expect(pace_a + pace_b).to eq '01:00'
    end

    it 'adds a RunbyTime to a Pace' do
      pace = Runby::Pace.new('00:01')
      time = Runby::RunbyTime.new('00:59')
      sum = pace + time
      expect(sum.class).to eq Runby::Pace
      expect(sum).to eq '01:00'
    end
  end

  describe 'Pace equality' do
    it 'should equal another Pace of the same value' do
      pace_a = Runby::Pace.new('09:59')
      pace_b = Runby::Pace.new('09:59')
      expect(pace_a).to eq pace_b
    end

    it 'should equal another string of the same face value' do
      pace = Runby::Pace.new('12:15')
      expect(pace).to eq '12:15'
    end

    it 'considers two paces of different units as unequal' do
      pace_km = Runby::Pace.new('09:59', :km)
      pace_mi = Runby::Pace.new('09:59', :mi)
      expect(pace_km == pace_mi).to eq false
    end

    describe '#almost_equals?' do
      it 'should equal another Pace within the given tolerance' do
        pace = Runby::Pace.new('01:00')
        low_pace = Runby::Pace.new('00:58')
        high_pace = Runby::Pace.new('01:02')
        expect(pace.almost_equals?(low_pace, '00:02')).to be true
        expect(pace.almost_equals?(high_pace, '00:02')).to be true
      end

      it 'should not equal another Pace outside the given tolerance' do
        pace = Runby::Pace.new('01:00')
        too_low_pace = Runby::Pace.new('00:57')
        too_high_pace = Runby::Pace.new('01:03')
        expect(pace.almost_equals?(too_low_pace, '00:02')).to be false
        expect(pace.almost_equals?(too_high_pace, '00:02')).to be false
      end

      it 'compares a Pace against a string that is parsable as a Time' do
        pace = Runby::Pace.new('01:00')
        expect(pace.almost_equals?('00:58', '00:02')).to be true
        expect(pace.almost_equals?('01:02', '00:02')).to be true
      end

      it 'compares a Pace against a string that is parsable as a Pace' do
        pace = Runby::Pace.new('01:00 p/mi')
        expect(pace.almost_equals?('00:58 p/mi', '00:02')).to be true
        expect(pace.almost_equals?('01:02 p/mi', '00:02')).to be true
      end
    end
  end

  describe 'Pace comparisons' do
    it 'should be greater than another slower pace' do
      pace_a = Runby::Pace.new('05:59')
      pace_b = Runby::Pace.new('06:00')
      expect(pace_a > pace_b).to be true
    end

    it 'should be greater than or equal to another slower or identical pace' do
      pace_a = Runby::Pace.new('05:59')
      pace_b = Runby::Pace.new('06:00')
      pace_a_clone = Runby::Pace.new(pace_a)
      expect(pace_a >= pace_b).to be true
      expect(pace_a >= pace_a_clone).to be true
    end

    it 'should be less than another faster pace' do
      pace_a = Runby::Pace.new('06:00')
      pace_b = Runby::Pace.new('05:59')
      expect(pace_a < pace_b).to be true
    end

    it 'should be less than or equal to another faster or identical pace' do
      pace_a = Runby::Pace.new('06:00')
      pace_b = Runby::Pace.new('05:59')
      pace_a_clone = Runby::Pace.new(pace_a)
      expect(pace_a <= pace_b).to be true
      expect(pace_a <= pace_a_clone).to be true
    end

    it 'considers a pace of 00:00 as slower than a pace of 00:01' do
      pace_a = Runby::Pace.new('00:00')
      pace_b = Runby::Pace.new('00:01')
      expect(pace_a < pace_b).to be true
    end

    it 'considers two paces of 00:00 to be equal' do
      pace_a = Runby::Pace.new('00:00')
      pace_b = Runby::Pace.new('00:00')
      expect(pace_a == pace_b).to be true
    end

    it 'supports comparing paces of difference Distances' do
      pace_a = Runby::Pace.new('9:59 p/km')
      pace_b = Runby::Pace.new('10:00 p/mi')
      # Note that pace A is way slower than pace B
      expect(pace_a < pace_b).to be true
      expect(pace_a > pace_b).to be false
    end
  end

  describe '#to_s' do
    it 'returns "<time> per <long distance>" if "format" is :long (default)' do
      distance = Runby::Distance.new :mi, 5
      pace = Runby::Pace.new('09:59', distance)
      expect(pace.to_s(format: :long)).to eq '9:59 per 5 miles'
    end

    it 'returns "<time> p/<short distance>" if "format" is :short' do
      distance = Runby::Distance.new :mi, 5
      pace = Runby::Pace.new('09:59', distance)
      expect(pace.to_s(format: :short)).to eq '9:59 p/5mi'
    end

    it 'does not show multiplier unless greater than 1 (all formats)' do
      distance = Runby::Distance.new :mi
      pace = Runby::Pace.new('09:59', distance)
      expect(pace.to_s(format: :short)).to eq '9:59 p/mi'
      expect(pace.to_s(format: :long)).to eq '9:59 per mile'
    end
  end

  describe '#as_speed' do
    it 'converts the Pace to a Speed' do
      pace = Runby::Pace.new('8:34', :mi)
      mph = pace.as_speed
      expect(mph).to eq '7mi/ph'
    end

    it 'returns a speed of 0 if the time component is 0:00' do
      speed = Runby::Pace.new('0:00', :mi).as_speed
      expect(speed).to eq '0mi/ph'
    end
  end

  describe 'pace calculations' do
    it 'calculates the distance traveled at this pace over a given time' do
      pace = Runby::Pace.new('06:00')
      expect(pace.distance_covered_over_time('60:00')).to be_within(0.01).of(10)
    end
  end
end