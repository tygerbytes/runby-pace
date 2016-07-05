require_relative '../../spec_helper'

describe RunbyPace::RunTypes do

  run_types = RunbyPace::RunTypes

  describe '#find_divisor' do
    it 'finds the correct radius divisor for a set of golden paces' do
      expect(run_types::find_divisor(run_types::FastTempoRun::GoldenPaces.fast, '00:01')).to eq 4.025
    end
  end
end