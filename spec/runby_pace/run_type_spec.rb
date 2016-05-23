require_relative '../spec_helper'

describe RunbyPace::RunTypes do

  runs = RunbyPace::RunTypes

  describe runs::LongRun do
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

      long_run = runs::LongRun.new

      golden_paces.each do |five_k, golden_pace|
        calculated_pace = long_run.pace(five_k)
        expect(calculated_pace).to be_within_seconds(golden_pace, '00:02')
      end
    end
  end
end
