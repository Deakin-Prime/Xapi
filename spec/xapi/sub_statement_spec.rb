# encoding: utf-8
require 'spec_helper'

describe Xapi::SubStatement do
  include Helpers

  it 'should serialize and deserialize' do
    statement = Xapi::SubStatement.new
    statement.actor = get_agent('Joe', 'mbox', 'mailto:joe@example.com')
    context = Xapi::Context.new
    context.language = 'en-US'
    statement.context = context

    activity = Xapi::Activity.new
    activity.id = 'http://example.com/activity'
    statement.object = activity

    result = Xapi::Result.new
    result.completion = true
    statement.result = result

    statement.timestamp = Time.now

    verb = Xapi::Verb.new
    verb.id = 'http://example.com/verb'
    statement.verb = verb

    assert_serialize_and_deserialize(statement)
  end
end
