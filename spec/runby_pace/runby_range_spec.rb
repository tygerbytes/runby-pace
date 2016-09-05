require_relative '../spec_helper'

describe Runby::RunbyRange do
  it 'cannot be instantiated directly' do
    expect { Runby::RunbyRange.new }.to raise_error 'RunbyRange is a base class for PaceRange and SpeedRange. Instantiate one of them instead.'
  end
end
