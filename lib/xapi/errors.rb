# encoding: utf-8
module Xapi
  module Errors

    # Raised when an incompatible version is used
    IncompatibleTCAPIVersion = Class.new(StandardError)

  end
end