
require 'runby_pace/version'
Dir[File.dirname(__FILE__) + '/runby_pace/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/runby_pace/run_types/*.rb'].each { |file| require file }

module RunbyPace
end