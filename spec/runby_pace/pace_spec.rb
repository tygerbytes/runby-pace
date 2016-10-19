require_relative '../spec_helper'

describe Runby::Pace do
  it 'represents a "pace" such as 4:59 per mile' do
    distance = Runby::Distance.new(:mi)
    pace = Runby::Pace.new('4:59', distance)
    expect(pace.to_s).to eq '4:59 per mile'
  end

  it 'encapsulates a distance (in units) and the time in which it was performed' do
    pace = Runby::Pace.new('20:00', '5K')
    expect(pace.time).to eq '20:00'
    expect(pace.distance.to_s).to eq '5 kilometers'
  end

  describe 'Pace initialization' do
    it 'is initialized by a time and a distance' do
      time = Runby::RunbyTime.new('11:01')
      distance = Runby::Distance.new(:km, 3)
      pace = Runby::Pace.new(time, distance)
      expect(pace.distance.to_s).to eq '3 kilometers'
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
        expect(pace.distance.to_s).to eq '5 kilometers'
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
    end
  end

  describe 'Pace comparisons' do
    it 'should be greater than another pace pace of lesser value' do
      pace_a = Runby::Pace.new('00:01')
      pace_b = Runby::Pace.new('00:00')
      expect(pace_a > pace_b).to be true
    end

    it 'should be greater than or equal to another pace pace of lesser or equal value' do
      pace_a = Runby::Pace.new('00:01')
      pace_b = Runby::Pace.new('00:00')
      pace_a_clone = Runby::Pace.new(pace_a)
      expect(pace_a >= pace_b).to be true
      expect(pace_a >= pace_a_clone).to be true
    end

    it 'should be less than another pace pace of greater value' do
      pace_a = Runby::Pace.new('00:00')
      pace_b = Runby::Pace.new('00:01')
      expect(pace_a < pace_b).to be true
    end

    it 'should be less than or equal to another pace pace of greater or equal value' do
      pace_a = Runby::Pace.new('00:00')
      pace_b = Runby::Pace.new('00:01')
      pace_a_clone = Runby::Pace.new(pace_a)
      expect(pace_a <= pace_b).to be true
      expect(pace_a <= pace_a_clone).to be true
    end
  end
end