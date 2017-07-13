require_relative '../../spec_helper'

describe Runby::Utility::ParameterSanitizer do
  describe 'purpose' do
    it 'helps clarify the intent of parameter sanitization code' do

      def example_method(time)
        time = Runby.sanitize(time).as(Runby::RunbyTime)
        # ...
        time
      end
      expect(example_method('5:00').class).to be Runby::RunbyTime
    end

    it 'defines a #sanitize shortcut to make the class easier to work with' do
      speed = Runby::Speed.new('5 miles per hour')
      short_form = Runby.sanitize(speed).as(Runby::Speed)
      long_form = Runby::Utility::ParameterSanitizer.sanitize(speed).as(Runby::Speed)
      expect(short_form).to eq long_form
    end

    it 'expects the target type in ..as(type) to have a "parse" class method.' do
      expected_error = "Unable to sanitize parameter of type String. Missing 'parse' method."
      expect { Runby.sanitize(123).as(String) }.to raise_error expected_error
    end

    it 'returns the parameter untouched if it is already of the target type' do
      pace = Runby::Pace.new('10:00 per mile')
      sanitized_pace = Runby.sanitize(pace).as(Runby::Pace)
      expect(sanitized_pace.object_id).to eq pace.object_id
    end
  end
end
