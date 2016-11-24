# encoding: utf-8
module Xapi
  module Statements
    class StatementsBase

      attr_accessor :actor, :verb, :object, :result, :context, :timestamp, :attachments, :voided

      def initialize(options={}, &block)
        @attachments = []
        json = options.fetch(:json, nil)
        if json
          attributes = JSON.parse(json)
          self.actor = attributes['actor']['member'] ? Xapi::Group.new(json: attributes['actor'].to_json) : Xapi::Agent.new(json: attributes['actor'].to_json) if attributes['actor']
          self.verb = Xapi::Verb.new(json: attributes['verb'].to_json) if attributes['verb']
          object_node = attributes['object']
          if object_node
            case object_node['objectType']
              when 'Group', 'Agent'
                self.object = Xapi::Agent.new(json: object_node.to_json)
              when 'StatementRef'
                self.object = Xapi::StatementRef.new(json: object_node.to_json)
              when 'SubStatement'
                self.object = Xapi::SubStatement.new(json: object_node.to_json)
              else
                self.object = Xapi::Activity.new(json: object_node.to_json)
            end
          end
          self.result = Xapi::Result.new(json: attributes['result'].to_json) if attributes['result']
          self.context = Xapi::Context.new(json: attributes['context'].to_json) if attributes['context']
          self.timestamp = Time.parse(attributes['timestamp']) if attributes['timestamp']
          self.voided = attributes['voided'] if attributes['voided']
          if attributes['attachments']
            attributes['attachments'].each do |attachment|
              attachments << Xapi::Attachment.new(json: attachment.to_json)
            end
          end
        else
          self.actor = options.fetch(:actor, nil)
          self.verb = options.fetch(:verb, nil)
          self.object = options.fetch(:object, nil)
          self.result = options.fetch(:result, nil)
          self.context = options.fetch(:context, nil)
          self.timestamp = options.fetch(:timestamp, nil)
          self.attachments = options.fetch(:attachments, nil)
          self.voided = options.fetch(:voided, nil)

          if block_given?
            block[self]
          end
        end
      end

      def serialize(version)
        node = {}
        node['actor'] = actor.serialize(version)
        node['verb'] = verb.serialize(version)
        node['object'] = object.serialize(version)
        node['result'] = result.serialize(version) if result
        node['context'] = context.serialize(version) if context
        node['timestamp'] = timestamp.strftime('%FT%T%:z') if timestamp
        if version.ordinal <= Xapi::TCAPIVersion::V100.ordinal
          if attachments && attachments.any?
            node['attachments'] = attachments.map {|element| element.serialize(version)}
          end
        end
        node
      end
    end
  end
end
