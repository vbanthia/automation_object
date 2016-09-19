# frozen_string_literal: true
require_relative '_proxy'

module AutomationObject
  module Dsl
    # ElementArray DSL Class
    class ElementArray < Base
    end

    # Proxy for ElementArray
    class ElementArrayProxy < Proxy
      # @param [AutomationObject::BluePrint::Composite::ElementArray] blue_prints
      # @param [AutomationObject::State::Session] state
      # @param [Symbol] name
      def initialize(blue_prints, state, name)
        super ElementArray, blue_prints, state, name
      end

      # @param [Symbol] method
      # @param [Array, nil] args
      # @param [Proc] block
      def method_missing(method, *args, &block)
        # If Screen class has the method defined, then don't load
        return super if ElementArray.method_defined?(method)

        if @subject.nil?
          puts "@state.load(:element_array, #{@name})"
          @subject = @state.load(:element_array, @name)
        end

        super
      end

      def respond_to_missing?(method, include_private = false)
        @subject.respond_to_missing?(method, include_private)
      end
    end
  end
end
