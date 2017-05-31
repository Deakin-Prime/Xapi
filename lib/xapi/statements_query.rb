# encoding: utf-8
module Xapi
  class StatementsQuery

    attr_accessor :version, :verb_id
    attr_accessor :agent, :activity_id, :registration, :related_activities, :related_agents
    attr_accessor :stored_since, :stored_until, :limit, :format, :ascending

    def initialize(&block)
      self.version = TCAPIVersion::V101
      if block_given?
        block[self]
      end
    end

    def verb_id=(value)
      if value.is_a?(Verb)
        @verb_id = value.id
      else
        @verb_id = value
      end
    end

    def parameter_map
      params = {}
      params['agent'] = agent.object_type.eql?("Group") ? {"account": {"homePage": agent.account.homePage, "name": agent.account.name}}.to_json : {"mbox":agent.mbox}.to_json if agent
      params['verb'] = verb_id.to_s if verb_id
      params['activity'] = activity_id.to_s if activity_id
      params['registration'] = registration if registration
      params['related_activities'] = related_activities if related_activities
      params['related_agents'] = related_agents if related_agents
      params['since'] = stored_since.strftime('%FT%T%:z') if stored_since
      params['until'] = stored_until.strftime('%FT%T%:z') if stored_until
      params['limit'] = limit if limit
      params['format'] = format if format
      params['ascending'] = ascending if ascending

      params
    end

  end
end
