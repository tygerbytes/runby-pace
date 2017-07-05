# frozen_string_literal: true

module Runby
  # Helper class which parses strings and returns new RunbyTime(s)
  class RunbyTimeParser
    def self.parse(str)
      time = str.to_s.strip.chomp

      if time.match?(/^\d?\d:\d\d:\d\d$/)
        parts = time.split(':')
        hours_part = parts[0].to_i
        minutes_part = parts[1].to_i
        seconds_part = parts[2].to_i
      elsif time.match?(/^\d?\d:\d\d$/)
        parts = time.split(':')
        hours_part = 0
        minutes_part = parts[0].to_i
        seconds_part = parts[1].to_i
      elsif time.match?(/^\d+$/)
        hours_part = 0
        minutes_part = time.to_i
        seconds_part = 0
      elsif time.match?(/^\d+[,. ]\d+$/)
        parts = time.split(/[,. ]/)
        hours_part = 0
        minutes_part = parts[0].to_i
        seconds_part = (parts[1].to_i / 10.0 * 60).to_i
      else
        raise 'Invalid time format'
      end

      raise 'Hours must be less than 24' if hours_part > 23
      raise 'Minutes must be less than 60 if hours are supplied' if hours_part.positive? && minutes_part > 59
      raise 'Minutes must be less than 99 if no hours are supplied' if hours_part.zero? && minutes_part > 99
      raise 'Seconds must be less than 60' if seconds_part > 59
      hours_part_formatted = ''
      if hours_part.positive?
        hours_part_formatted = "#{hours_part.to_s.rjust(2, '0')}:"
      end
      time_formatted = "#{hours_part_formatted}#{minutes_part.to_s.rjust(2, '0')}:#{seconds_part.to_s.rjust(2, '0')}"

      RunbyTime.new(time_s: time_formatted, hours_part: hours_part, minutes_part: minutes_part, seconds_part: seconds_part)
    end
  end
end