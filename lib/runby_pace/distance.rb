# frozen_string_literal: true

module Runby
  # Represents a distance (distance UOM and multiplier)
  class Distance
    include Comparable

    attr_reader :uom, :multiplier

    def self.new(uom = :km, multiplier = 1)
      return uom if uom.is_a? Distance
      return Distance.parse uom if uom.is_a? String
      super
    end

    def initialize(uom = :km, multiplier = 1)
      case uom
      when DistanceUnit
        init_from_distance_unit uom, multiplier
      when Symbol
        init_from_symbol uom, multiplier
      else
        raise 'Invalid distance unit of measure'
      end
      freeze
    end

    def convert_to(target_uom)
      target_uom = DistanceUnit.new target_uom unless target_uom.is_a?(DistanceUnit)
      return self if @uom == target_uom
      target_multiplier = kilometers / (target_uom.conversion_factor * 1.0)
      Distance.new target_uom, target_multiplier
    end

    def meters
      kilometers * 1000.0
    end

    def kilometers
      @multiplier * @uom.conversion_factor
    end

    def self.parse(str)
      str = str.strip.chomp.downcase
      multiplier = str.scan(/[\d,.]+/).first
      multiplier = multiplier.nil? ? 1 : multiplier.to_f
      uom = str.scan(/[-_a-z ]+$/).first
      raise "Unable to find distance unit in '#{str}'" if uom.nil?

      parsed_uom = Runby::DistanceUnit.parse uom
      raise "'#{uom.strip}' is not recognized as a distance unit" if parsed_uom.nil?

      new parsed_uom, multiplier
    end

    def self.try_parse(str)
      distance, error_message = nil
      begin
        distance = parse str
      rescue StandardError => ex
        error_message = ex.message.to_s
      end
      { distance: distance, error: error_message }
    end

    def to_s(format: :short)
      formatted_multiplier = format('%g', @multiplier.round(2))
      case format
      when :short then "#{formatted_multiplier} #{@uom.to_s(format: format)}"
      when :long then "#{formatted_multiplier} #{@uom.to_s(format: format, pluralize: (@multiplier > 1))}"
      else raise "Invalid string format #{format}"
      end
    end

    # @param [Distance, String] other
    def <=>(other)
      raise "Cannot compare Runby::Distance to #{other.class}(#{other})" unless [Distance, String].include? other.class
      if other.is_a?(String)
        return 0 if to_s == other || to_s(format: :long) == other
        return self <=> Distance.try_parse(other)[:distance]
      end
      kilometers <=> other.kilometers
    end

    # @param [Distance] other
    # @return [Distance]
    def +(other)
      raise "Cannot add Runby::Distance to #{other.class}" unless other.is_a?(Distance)
      sum_in_km = Distance.new(:km, kilometers + other.kilometers)
      sum_in_km.convert_to(@uom)
    end

    # @param [Distance] other
    # @return [Distance]
    def -(other)
      raise "Cannot add Runby::Distance to #{other.class}" unless other.is_a?(Distance)
      sum_in_km = Distance.new(:km, kilometers - other.kilometers)
      sum_in_km.convert_to(@uom)
    end

    # @param [Numeric] other
    # @return [Distance]
    def *(other)
      raise "Cannot multiply Runby::Distance by #{other.class}" unless other.is_a?(Numeric)
      product_in_km = Distance.new(:km, kilometers * other)
      product_in_km.convert_to(@uom)
    end

    # @param [Numeric, Distance] other
    # @return [Distance, Numeric]
    def /(other)
      raise "Cannot divide Runby::Distance by #{other.class}" unless other.is_a?(Numeric) || other.is_a?(Distance)
      if other.is_a?(Numeric)
        quotient_in_km = Distance.new(:km, kilometers / other)
        return quotient_in_km.convert_to(@uom)
      elsif other.is_a?(Distance)
        return kilometers / other.kilometers
      end
    end

    private

    def init_from_distance_unit(uom, multiplier)
      @uom = uom
      @multiplier = multiplier
    end

    def init_from_symbol(distance_uom_symbol, multiplier)
      raise "Unknown unit of measure #{distance_uom_symbol}" unless Runby::DistanceUnit.known_uom? distance_uom_symbol
      raise 'Invalid multiplier' unless multiplier.is_a?(Numeric)
      @uom = DistanceUnit.new distance_uom_symbol
      @multiplier = multiplier * 1.0
    end
  end
end
