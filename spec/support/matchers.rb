RSpec::Matchers.define :be_within_seconds do |expected_time_s, seconds_variation_s|
  match do |actual_time|
    seconds = RunbyPace::PaceTime.new(seconds_variation_s)
    expected_time = RunbyPace::PaceTime.new(expected_time_s)
    assert(actual_time >= expected_time - seconds && actual_time <= expected_time + seconds)
  end

  failure_message do |actual_time|
    "expected a time between #{format_time_range(expected_time_s, seconds_variation_s)}. Got #{actual_time}."
  end

  failure_message_when_negated do |actual_time|
    "expected a time outside #{format_time_range(expected_time_s, seconds_variation_s)}. Got #{actual_time}."
  end

  description do
    "match a runby time of #{expected_time_s} varying by no more than #{seconds_variation_s} seconds"
  end

  def format_time_range(expected_time, variation_seconds)
    slow_time = expected_time - variation_seconds
    fast_time = expected_time + variation_seconds
    "#{slow_time}-#{fast_time}"
  end
end
