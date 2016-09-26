RSpec::Matchers.define :be_within_seconds do |expected_time, seconds_variation|
  match do |actual_time|
    # First make sure everything is a RunbyTime
    seconds = Runby::RunbyTime.new(seconds_variation)
    expected_time = Runby::RunbyTime.new(expected_time)
    if actual_time.is_a? Runby::Pace
      actual_time = actual_time.time
    elsif actual_time.is_a? String
      actual_time = Runby::RunbyTime.new(actual_time)
    end
    actual_time.almost_equals?(expected_time, seconds)
  end

  failure_message do |actual_time|
    "expected a time between #{format_time_range(expected_time, seconds_variation)}. Got #{actual_time}."
  end

  failure_message_when_negated do |actual_time|
    "expected a time outside #{format_time_range(expected_time, seconds_variation)}. Got #{actual_time}."
  end

  description do
    "match a runby time of #{expected_time} varying by no more than #{seconds_variation} seconds"
  end

  def format_time_range(expected_time_s, seconds_variation_s)
    expected_time = Runby::RunbyTime.new(expected_time_s)
    seconds_variation = Runby::RunbyTime.new(seconds_variation_s)
    slow_time = expected_time - seconds_variation
    fast_time = expected_time + seconds_variation
    "#{slow_time}-#{fast_time}"
  end
end
