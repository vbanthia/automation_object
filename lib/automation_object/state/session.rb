require_relative 'error'

require_relative 'composite/top'

module AutomationObject
  module State
    class Session
      # @return [AutomationObject::Driver::Driver]
      attr_accessor :driver

      # @return [AutomationObject::BluePrint::Composite::Top]
      attr_accessor :blue_prints

      # @return [AutomationObject::State::Composite::Top]
      attr_accessor :composite

      # @param [AutomationObject::Driver::Driver] driver
      # @param [AutomationObject::BluePrint::Composite::Top] blue_prints
      def initialize(driver, blue_prints)
        self.driver = driver
        self.composite = Composite::Top.new(self, driver, blue_prints)
      end

      def load(type, name)
        case type
          when :screen
            unless self.composite.live_screens.include?(name)
              raise AutomationObject::State::ScreenNotActiveError.new(name)
            end

            # Set the current window by name
            self.composite.window = name
          when :modal
            unless self.composite.window.modal == name
              raise AutomationObject::State::ModalNotActiveError.new(name)
            end
          when :element, :element_array, :element_hash
            return self.composite.get_object(type, name)
          else
            raise AutomationObject::State::UndefinedLoadTypeError.new
        end
      end
    end
  end
end
