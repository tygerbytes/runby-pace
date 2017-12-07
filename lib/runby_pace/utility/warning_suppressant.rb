# frozen_string_literal: true

module Runby
  def self.with_no_warnings
    warning_level = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = warning_level
    result
  end
end
