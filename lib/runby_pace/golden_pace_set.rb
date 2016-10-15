module Runby

  # TODO:
  class GoldenPaceSet
    attr_reader :paces

    @@FASTEST = :'14:00'
    @@SLOWEST = :'42:00'

    def initialize(paces_hash)

      @paces = paces_hash
    end

    def each
      @paces.each do |h, v|
        yield h, v
      end
    end

    def first
      @paces[@@FASTEST]
    end
    alias :fastest :first

    def last
      @paces[@@SLOWEST]
    end
    alias :slowest :last

    def self.new_from_endpoints(fastest, slowest)
      GoldenPaceSet.new({@@FASTEST => fastest, @@SLOWEST => slowest})
    end
  end
end
