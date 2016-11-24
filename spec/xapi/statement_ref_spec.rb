# encoding: utf-8
require 'spec_helper'

describe Xapi::StatementRef do
  include Helpers

  it 'sets the object type' do
    ref = Xapi::StatementRef.new
    expect(ref.object_type).to eq('StatementRef')
  end

  it 'should serialize and deserialize' do
    ref = Xapi::StatementRef.new
    ref.id = SecureRandom.uuid

    assert_serialize_and_deserialize(ref)
  end

end
