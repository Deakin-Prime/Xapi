# encoding: utf-8
require 'spec_helper'

describe Xapi::ContextActivities do
  include Helpers

  it 'should serialize and deserialize' do
    context = Xapi::ContextActivities.new
    activity = Xapi::Activity.new
    activity.id = 'http://example.com/parent'
    context.parent = [activity]

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/grouping'
    context.grouping = [activity]

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/other'
    context.other = [activity]

    assert_serialize_and_deserialize(context)
  end

  # 'category' arrived in 1.0.0, so confirm it works in everything after that point, which is to say not 0.95
  it 'should work with category in version 1.0.0 and later' do
    context = Xapi::ContextActivities.new
    activity = Xapi::Activity.new
    activity.id = 'http://example.com/parent'
    context.parent = [activity]

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/grouping'
    context.grouping = [activity]

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/other'
    context.other = [activity]

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/category'
    context.category = [activity]

    assert_serialize_and_deserialize_for_version(context, Xapi::TCAPIVersion::V101)
    assert_serialize_and_deserialize_for_version(context, Xapi::TCAPIVersion::V100)
  end

  # 'category' is not supported in 0.95, make sure it isn't
  it 'should fail with category in version 0.95 and later' do
    context = Xapi::ContextActivities.new

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/category'
    context.category = [activity]

    expect{assert_serialize_and_deserialize_for_version(context, Xapi::TCAPIVersion::V095)}.to raise_error(Xapi::Errors::IncompatibleTCAPIVersion)
  end
end