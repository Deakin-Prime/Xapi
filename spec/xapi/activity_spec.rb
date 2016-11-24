# encoding: utf-8
require 'spec_helper'

describe Xapi::Activity do
  include Helpers

  it 'sets the object type' do
    activity = Xapi::Activity.new
    expect(activity.object_type).to eq('Activity')
  end

  it 'should serialize and deserialize' do
    activity = Xapi::Activity.new
    activity.id = 'http://example.com/activity'
    definition = Xapi::ActivityDefinition.new
    map = {}
    map['en-US'] = 'Activity Definition'
    definition.name = map
    activity.definition = definition
    assert_serialize_and_deserialize(activity)
  end

end