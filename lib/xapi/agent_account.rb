# encoding: utf-8
require 'json'
module Xapi
  # Agent Account model class
  class AgentAccount

    attr_accessor :homePage, :name

    def initialize(options={}, &block)
      json = options.fetch(:json, nil)
      if json
        attributes = JSON.parse(json)
        self.name = attributes['name'] if attributes['name']
        self.homePage = attributes['homePage'] if attributes['homePage']
      else
        self.homePage = options.fetch(:home_page, nil)
        self.name =options.fetch(:name, nil)

        if block_given?
          block[self]
        end
      end
    end

    def serialize(version)
      node = {}
      node['name'] = name if name
      node['homePage'] = homePage if homePage
      node
    end

  end
end