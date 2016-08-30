module Runby
  # Represents a distance (distance UOM and multiplier)
  class Distance
    attr_reader :uom, :multiplier
    def initialize(distance_uom = :km, multiplier = 1)
      @uom = distance_uom
      @multiplier = multiplier
    end

    def to_s
      "#{@multiplier} #{pluralized_uom}"
    end

    def pluralized_uom
      uom_description = PaceUnits.description(@uom).downcase
      if @multiplier > 1 then
        uom_description += 's'
      end
      uom_description
    end
  end
end
