# frozen_string_literal: true

module Runby
  # Helper class which parses strings and returns new RunbyTime(s)
  class RunbyTimeParser
    def self.parse(str)
      time = str.to_s.strip.chomp
      if time_string?(time)
        parts = TimeParts.new(time.split(':').reverse)
      elsif integer?(time)
        parts = extract_minutes_from_integer time
      elsif decimal?(time)
        parts = extract_minutes_from_decimal time
      else
        raise 'Invalid time format'
      end
      RunbyTime.new(parts)
    end

    def self.decimal?(str)
      str.match?(/^\d+[,. ]\d+$/)
    end

    def self.integer?(str)
      str.match?(/^\d+$/)
    end

    def self.time_string?(str)
      str.match?(/^\d?\d(:\d\d)+$/)
    end

    def self.extract_minutes_from_decimal(decimal_str)
      decimal_parts = decimal_str.split(/[,. ]/)
      minutes = decimal_parts[0].to_i
      seconds = (decimal_parts[1].to_i / 10.0 * 60).to_i
      TimeParts.new([seconds, minutes])
    end

    def self.extract_minutes_from_integer(integer_str)
      TimeParts.new([0, integer_str.to_i])
    end

    # Encapsulates the parts of a time string
    class TimeParts
      def initialize(parts_array)
        @keys = { seconds: 0, minutes: 1, hours: 2 }
        @parts = Array.new(@keys.count, 0)
        Range.new(0, parts_array.count - 1).each { |i| @parts[i] = parts_array[i] }
        validate
        freeze
      end

      def [](key)
        i = @keys[key]
        @parts[i].to_i
      end

      def format
        time_f = +''
        @parts.reverse_each do |part|
          time_f << ':' << part.to_s.rjust(2, '0')
        end
        # Remove leading ':'
        time_f.slice!(0)
        # Remove leading '00:00...'
        time_f.sub!(/^(?:00:)+(\d\d:\d\d)/, '\1') if time_f.length > 5
        # If the time looks like 00:48, only show 0:48
        time_f.slice!(0) if time_f.slice(0) == '0'
        time_f
      end

      def validate
        raise 'Hours must be less than 24' if self[:hours] > 23
        raise 'Minutes must be less than 60 if hours are supplied' if self[:hours].positive? && self[:minutes] > 59
        raise 'Minutes must be less than 99 if no hours are supplied' if self[:hours].zero? && self[:minutes] > 99
        raise 'Seconds must be less than 60' if self[:seconds] > 59
      end
    end
  end
end
