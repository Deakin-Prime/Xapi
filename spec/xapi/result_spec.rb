# encoding: utf-8
require 'spec_helper'
require 'ruby-duration'

describe Xapi::Result do
  include Helpers

  it 'should serialize and deserialize' do
    result = Xapi::Result.new
    result.completion = true
    result.duration = Duration.new('P1DT8H')

    map = {}
    map['http://example.com/extension'] = 'extension value'
    result.extensions = map

    result.response = "Here's a response"

    score = Xapi::Score.new(raw: 0.43)
    result.score = score
    result.success = false

    assert_serialize_and_deserialize(result)

  end
end