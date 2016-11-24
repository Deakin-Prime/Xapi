# encoding: utf-8
module Xapi
  module Documents
    class AgentProfileDocument < Document

      attr_accessor :agent

      def initialize(&block)
        super(&block)
      end

    end
  end
end

