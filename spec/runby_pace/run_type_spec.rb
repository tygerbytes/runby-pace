require_relative '../spec_helper'

describe Runby::RunTypes do
  runs = Runby::RunTypes

  it 'provides a default description of the run type' do
    expect(Runby::RunType.new.description).to eq 'No description'
  end

  describe '#new_from_name' do
    it 'returns an initialized run type, given the name of an existing run type' do
      long_run = runs.new_from_name('LongRun')
      expect(long_run.description).to eq 'Long Run'
    end
  end

  describe '#enumerate_run_types' do
    it 'enumerates all of the possible run types' do
      run_types = runs.all
      expect(run_types).to include 'EasyRun'
      expect(run_types).to include 'LongRun'
    end
  end
end
