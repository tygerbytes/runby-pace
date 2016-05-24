module RunbyPace

  module RunTypes

    class LongRun < RunType
      def pace(five_k_time)
        RunbyPace::PaceRange.new('05:30', '06:19')
      end
    end
  end
end
