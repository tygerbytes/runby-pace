require_relative '../spec_helper'

describe Runby::GoldenPaceSet do
  it 'Maps a set of 5K race times with their pre-calculated pace recommendations.' do end

  describe 'GoldenPaceSet range initialization and creation' do
    it 'creates a GoldenPaceSet from a hash of 5K time symbols and recommended time strings' do
      hash = {'14:00':'4:00', '42:00':'20:00'}
      pace_set = Runby::GoldenPaceSet.new(hash)
      expect(pace_set.first).to eq '04:00'
      expect(pace_set.last).to eq '20:00'
    end

    describe '#new_from_endpoints' do
      it 'creates and returns a new GoldenPaceSet with only two entries' do
        pace_set = Runby::GoldenPaceSet.new_from_endpoints('10:00', '20:00')
        expect(pace_set.first).to eq '10:00'
        expect(pace_set.last).to eq '20:00'
      end
    end
  end

  describe '#enumerable' do
    it 'iterates through each 5K/pace pair in the set' do
      pace_set = Runby::GoldenPaceSet.new('20:00':'4:00', '25:00':'5:00', '30:00':'6:00')
      paces = pace_set.map { |_, pace| pace.time.to_s }
      expect(paces).to eq %w(4:00 5:00 6:00)
    end
  end

  describe '#first/#fastest' do
    it 'returns the first (or fastest) 5K/pace pair in the set' do
      pace_set = Runby::GoldenPaceSet.new_from_endpoints('10:00', '20:00')
      expect(pace_set.first).to eq '10:00'
      expect(pace_set.fastest).to eq '10:00'
    end
  end

  describe '#last/#slowest' do
    it 'returns the last (or slowest) 5K/pace pair in the set' do
      pace_set = Runby::GoldenPaceSet.new_from_endpoints('10:00', '20:00')
      expect(pace_set.last.to_s(format: :short)).to eq '20:00 p/km'
      expect(pace_set.slowest).to eq '20:00'
    end
  end
end
