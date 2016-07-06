module RunbyPace

  class RunType
    def description
      'No description'
    end

    def pace(five_k_time, distance_units = :km)
    end
  end

  module RunTypes
    def self.new_from_name(run_type_name)
      Object::const_get("RunbyPace::RunTypes::#{run_type_name}").new
    end
  end

end
