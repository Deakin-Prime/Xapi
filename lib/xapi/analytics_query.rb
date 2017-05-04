# encoding: utf-8
module Xapi
  class AnalyticsQuery

    attr_accessor :version, :verb_id
    attr_accessor :activity_id, :registration, :activity_type, :team_name

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
        @verb_id = Addressable::URI.parse(value)
      end
    end

    def parameter_map
      params = {}
      params['verb'] = verb_id.to_s if verb_id
      params['activity'] = activity_id.to_s if activity_id
      params['registration'] = registration if registration
      params['activity_type'] = activity_type if activity_type
      params['team_name'] = team_name if team_name

      params
    end

  end
end
