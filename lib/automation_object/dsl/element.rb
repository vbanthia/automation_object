# frozen_string_literal: true
require_relative '_proxy'

module AutomationObject
  module Dsl
    # Element DSL Class
    class Element < Base
    end

    # Proxy for Element
    class ElementProxy < Proxy
      # @param [AutomationObject::BluePrint::Composite::Element] blue_prints
      # @param [AutomationObject::State::Session] state
      # @param [Symbol] name
      def initialize(blue_prints, state, name)
        super Element, blue_prints, state, name
      end

      # @param [Symbol] method
      # @param [Array, nil] args
      # @param [Proc] block
      def method_missing(method, *args, &block)
        return super if Element.methods.include?(method)

        if @subject.is_a?(AutomationObject::Dsl::Element)
          #puts "@state.load(:element, #{@name})"
          @subject = @state.load(:element, @name)
        end

        super
      end
    end
  end
end
