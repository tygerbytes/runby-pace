require_relative '../spec_helper'

describe Runby::Speed do
  it 'represents a "speed" such as 7 miles per hour' do
    speed = Runby::Speed.new('7 miles')
    expect(speed.to_s).to eq '7 miles per hour'
  end

  describe 'Speed initialization' do
    it 'is initialized by a distance and defaults to "per hour"' do
      distance = Runby::Distance.new(:mi, 7)
      speed = Runby::Speed.new(distance)
      expect(speed.to_s).to eq '7 miles per hour'
    end
  end

  describe 'Speed parsing' do
    # TODO: Coming soon..
  end

  describe '#to_s' do
    it 'returns <distance> per hour if "format" is :long' do
      distance = Runby::Distance.new('9.9 miles')
      speed = Runby::Speed.new(distance)
      expect(speed.to_s(format: :long)).to eq '9.9 miles per hour'
    end

    it 'returns <distance>/ph if "format" is :short' do
      distance = Runby::Distance.new('9.9 miles')
      speed = Runby::Speed.new(distance)
      expect(speed.to_s(format: :short)).to eq '9.9mi/ph'
    end

  end

  describe '#as_pace' do
    it 'converts the speed into a new Pace' do
      speed = Runby::Speed.new(10, :mi)
      expect(speed.as_pace.to_s).to eq '6:00 per mile'
    end
  end
end