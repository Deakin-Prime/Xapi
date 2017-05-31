# encoding: utf-8
module Xapi
  # Activity model class
  class Activity

    attr_accessor :object_type, :definition
    attr_reader :id

    def initialize(options={}, &block)
      @object_type = 'Activity'
      json = options.fetch(:json, nil)
      if json
        attributes = JSON.parse(json)
        self.id =  attributes['id'] if attributes['id']
        self.definition = ActivityDefinition.new(json: attributes['definition'].to_json) if attributes['definition']
      else
        self.id = options.fetch(:id, nil)
        self.definition = options.fetch(:definition, nil)
        if block_given?
          block[self]
        end
      end
    end

    def id=(value)
      @id = value
    end

    def serialize(version)
      node = {}
      node['id'] = id.to_s if id
      node['definition'] = definition.serialize(version) if definition
      node
    end

  end
end