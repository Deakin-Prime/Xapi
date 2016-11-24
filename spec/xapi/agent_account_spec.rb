# encoding: utf-8
require 'spec_helper'

describe Xapi::AgentAccount do
  include Helpers

  it 'should serialize and deserialize' do
    account = Xapi::AgentAccount.new
    account.home_page = 'http://example.com'
    account.name = 'joeuser'
    assert_serialize_and_deserialize(account)
  end
end