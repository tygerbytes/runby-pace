# frozen_string_literal: true

def sanitize_arg(parameter)
  Runby::ParameterSanitizer.sanitize(parameter)
end

module Runby
  # Sanitizes method parameters
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
