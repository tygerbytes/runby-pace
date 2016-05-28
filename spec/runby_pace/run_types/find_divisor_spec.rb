require_relative '../../spec_helper'

describe RunbyPace::RunTypes do

  run_types = RunbyPace::RunTypes

  describe '#find_divisor' do
    it 'finds the correct radius divisor for a set of golden paces' do
      expect(run_types::find_divisor(run_types::LongRun::GoldenPaces.fast, '00:02')).to eq 2.125
    end
  end
end