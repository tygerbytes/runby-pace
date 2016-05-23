RSpec::Matchers.define :within_seconds do |seconds_s|
  match do |time|
    seconds = RunbyPace::PaceTime.new(seconds_s)
    assert(time >= time - seconds && time <= time + seconds)
  end

  failure_message_for_should do |time|
    "expected a time between #{format_range(time, seconds_s)}. Got #{time}."
  end

  failure_message_for_should_not do |time|
    "expected a time outside #{format_range(time, seconds_s)}. Got #{time}."
  end

  description do
    "match a runby time varying by no more than #{seconds_s} seconds"
  end

  def format_range(time, variation_seconds)
    slow_time = time - variation_seconds
    fast_time = time + variation_seconds
    "#{slow_time}-#{fast_time}"
  end
end
