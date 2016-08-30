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

    describe 'Time' do
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
    end

    describe 'Distance' do
      it 'defaults to 1 kilometer if not provided' do
        pace = Runby::Pace.new('59:59')
        expect(pace.distance.uom).to eq :km
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
end