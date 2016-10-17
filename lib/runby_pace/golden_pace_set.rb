module Runby

  # Maps a set of 5K race times with their pre-calculated pace recommendations.
  # This is useful in testing as well as defining the fastest and slowest supported 5K times.
  # GoldenPaceSet could conceivably be used to pre-compute a large number of recommended paces,
  #  thus reducing runtime CPU overhead.
  class GoldenPaceSet
    include Enumerable

    attr_reader :paces

    # The fastest 5K time supported by RunbyPace
    @@FASTEST_5K = :'14:00'

    # The slowest 5K time supported by RunbyPace
    @@SLOWEST_5K = :'42:00'

    # @param [Hash] paces_hash is a hash mapping 5K time symbols to times, represented as strings.
    # An example paces_hash is {'14:00':'4:00', '15:00':'4:55'}
    def initialize(paces_hash)
      @paces = {}
      paces_hash.each { |five_k_time, recommended_pace| @paces[five_k_time.to_sym] = Pace.new(recommended_pace) }
    end

    def each(&block)
      @paces.each do |h, v|
        block.call(h, v)
      end
    end

    # Returns first/fastest recommended pace in the set
    def first
      @paces[@@FASTEST_5K]
    end
    alias :fastest :first

    # Return the last/slowest recommended pace in the set
    def last
      @paces[@@SLOWEST_5K]
    end
    alias :slowest :last

    # Creates and returns a new GoldenPaceSet with only two entries
    def self.new_from_endpoints(fastest, slowest)
      GoldenPaceSet.new({@@FASTEST_5K => fastest, @@SLOWEST_5K => slowest})
    end
  end
end
