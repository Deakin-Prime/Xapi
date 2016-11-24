# encoding: utf-8
module Xapi
  module Documents
    class StateDocument < Document

      attr_accessor :activity, :agent, :registration

      def initialize(&block)
        super(&block)
      end

    end
  end
end

