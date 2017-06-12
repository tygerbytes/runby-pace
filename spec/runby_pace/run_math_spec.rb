require_relative '../spec_helper'

describe Runby::RunMath do
  describe 'finishing race time predictions' do
    it 'estimates your 5K finish time based on performance in another race' do
      five_k_time = Runby::RunMath.predict_race_time('10km', '1:00:00', '5km')
      expect(five_k_time).to eq '28:46'
    end
  end
end
