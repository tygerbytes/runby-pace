require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'runby_pace'

# Require rspec support files like custom matchers
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }
