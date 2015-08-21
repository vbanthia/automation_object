require_relative 'composite'

require_relative 'hook'
require_relative 'modal'
require_relative 'element'
require_relative 'element_array'
require_relative 'element_group'
require_relative 'element_hash'

module AutomationObject
  module State
    module BluePrintAdapter
      class Screen < Composite
        has_one :load, interface: Hook

        #Children for this composite
        has_many :modals, interface: Screen

        has_many :elements, interface: Element
        has_many :element_arrays, interface: ElementArray
        has_many :element_groups, interface: ElementGroup
        has_many :element_hashes, interface: ElementHash
      end
    end
  end
end