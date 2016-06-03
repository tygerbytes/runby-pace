module RunbyPace

  class RunType
    def description
      'No description'
    end

    def pace(five_k_time)
    end
  end

  module RunTypes
    def self.new_from_name(run_type_name)
      Object::const_get("RunbyPace::RunTypes::#{run_type_name}").new
    end

    def self.enumerate_run_types
      run_type_files = Dir.entries('./lib/runby_pace/run_types').select { |file| /.*_run\.rb/ =~ file }

      run_type_files.map do |filename|
        filename_sans_extension = filename[0, filename.length - 3]
        parts = filename_sans_extension.to_s.downcase.split(/_|\./)
        run_type = ''
        parts.each { |part|
          run_type += part[0].upcase + part[-(part.length - 1), part.length - 1]
        }
        run_type
      end
    end
  end

end
