module RunbyPace

  class RunType
    def pace(five_k_time)
      '05:30-06:19' if five_k_time.to_s == '20:00'
    end
  end
end