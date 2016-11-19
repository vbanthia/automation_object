# frozen_string_literal: true
require_relative '_base'
require_relative '../error'

require_relative 'element'
require_relative 'element_array'
require_relative 'element_hash'

module AutomationObject
  module State
    module Composite
      # Modal composite for managing state
      class Modal < Base
        has_one :load, interface: Hook

        has_many :elements, interface: Element
        has_many :element_arrays, interface: ElementArray
        has_many :element_hashes, interface: ElementHash

        def get(type, name)
          case type
          when :element
            elements[name].load
          when :element_array
            element_arrays[name].load
          when :element_hash
            element_hashes[name].load
          else
            raise AutomationObject::State::UndefinedLoadTypeError
          end
        end

        # Whether or not modal is active
        attr_writer :active

        # @return [Boolean] screen is active or not
        def active
          @active ||= false
        end
      end
    end
  end
end
