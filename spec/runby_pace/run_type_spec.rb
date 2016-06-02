require_relative '../spec_helper'

describe RunbyPace::RunTypes do

  runs = RunbyPace::RunTypes

  it 'provides a default description of the run type' do
    expect(RunbyPace::RunType.new.description).to eq 'No description'
  end

  describe '#new_from_name' do
    it 'returns an initialized run type, given the name of an existing run type' do
      long_run = RunbyPace::RunTypes::new_from_name('LongRun')
      expect(long_run.description).to eq 'Long Run'
    end
  end

end