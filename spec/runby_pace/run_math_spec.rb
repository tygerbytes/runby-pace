require_relative '../spec_helper'

describe Runby::RunMath do
  describe '5K race time conversions' do
    it 'estimates your 5K finish time based on performance in another race' do
      five_k_time = Runby::RunMath.predict_five_k_time('10km', '1:00:00')

      pending('implementation of race time conversions')
      expect(five_k_time).to eq '28:46'
    end
  end
end
