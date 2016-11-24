# encoding: utf-8
module Xapi
  module TCAPIVersion

    V101 = {
        to_s: '1.0.1',
        get_value: proc{'1.0.1'}
    }

    V100 = {
        to_s: '1.0.0',
        get_value: proc{'1.0.0'}
    }

    V095 = {
        to_s: '0.95',
        get_value: proc{'0.95'}
    }

    def latest_version
      V101
    end

    extend Xapi::Enum

  end
end
