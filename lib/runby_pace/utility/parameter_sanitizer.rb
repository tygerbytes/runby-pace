# frozen_string_literal: true

module Runby
  module Utility
    # Helps sanitize method parameters. (See RSpec documentation for examples)
    class ParameterSanitizer
      attr_reader :parameter

      def initialize(parameter)
        @parameter = parameter
      end

      def self.sanitize(parameter)
        ParameterSanitizer.new parameter
      end

      def as(type)
        return @parameter if @parameter.is_a?(type)
        raise "Unable to sanitize parameter of type #{type}. Missing 'parse' method." unless type.respond_to? :parse
        type.parse(@parameter)
      end
    end
  end

  # Just a shortcut method
  def self.sanitize(parameter)
    Runby::Utility::ParameterSanitizer.sanitize(parameter)
  end
end
