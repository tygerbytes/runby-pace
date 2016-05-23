require_relative '../spec_helper'

describe RunbyPace::RunTypes do

  describe RunbyPace::RunTypes::LongRun do
    it 'calculates a set of long run paces correctly' do
      golden_paces = {
          '14:00': '04:00',
          '15:00': '04:16',
          '20:00': '05:31',
          '25:00': '06:44',
          '30:00': '07:54',
          '35:00': '09:01',
          '40:00': '10:07',
          '42:00': '10:32'
      }

    end
  end


end