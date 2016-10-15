module Runby

  # TODO:
  class GoldenPaceSet
    attr_reader :paces

    FASTEST = :'14:00'
    SLOWEST = :'42:00'

    def initialize(paces_hash)
      @paces = paces_hash
    end

    def each
      @paces.each do |h, v|
        yield h, v
      end
    end

    def first
      @paces[:'14:00']
    end
    alias :fastest :first

    def last
      @paces[:'42:00']
    end
    alias :slowest :last

    def self.new_from_endpoints(fastest, slowest)
      GoldenPaceSet.new({'14:00': fastest, '42:00': slowest})
    end
  end
end
