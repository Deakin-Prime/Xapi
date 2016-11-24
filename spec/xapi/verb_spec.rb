# encoding: utf-8
require 'spec_helper'

describe Xapi::Verb do
  include Helpers

  it 'should serialize and deserialize' do
    verb = Xapi::Verb.new
    verb.id = 'http://example.com/attempted'
    map = {}
    map['en-US'] = 'attempted'
    verb.display = map

    assert_serialize_and_deserialize(verb)

  end
end
