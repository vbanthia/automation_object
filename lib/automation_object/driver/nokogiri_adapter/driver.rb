require_relative 'session'

require_relative '../driver'

require_relative '../element'
require_relative 'element'

module AutomationObject
  module Driver
    module NokogiriAdapter
      #Driver for Nokogiri
      #Conforms to interface and provides Selenium type functionality for XML only functionality
      class Driver
        # @return [AutomationObject::Driver::NokogiriAdapter::Session]
        attr_accessor :session

        def initialize
          self.session = Session.new
        end

        # Navigates current window to a given url
        # @param url [String] navigate to the following url
        # @return [void]
        def get(url)
          self.session.get(url)
        end

        # Set timeout wait
        # @param timeout [Integer] the timeout in seconds
        # @return [void]
        def set_wait(timeout = nil)
        end

        # @param selector_type [Symbol] selector type, :css, :xpath, etc...
        # @param selector_path [String] path to element
        # @return [Boolean] element exists?
        def exists?(selector_type, selector_path)
          elements = self.get_elements(selector_type, selector_path)
          return (elements.length > 0) ? true : false
        end

        # @param selector_type [Symbol] selector type, :css, :xpath, etc...
        # @param selector_path [String] path to element
        # @return [AutomationObject::Driver::Element] element
        def find_element(selector_type, selector_path)
          elements = self.get_elements(selector_type, selector_path)
          raise NoSuchElementError if elements.length == 0

          return AutomationObject::Driver::Element.new(
              AutomationObject::Driver::NokogiriAdapter::Element.new(driver: self, element: elements.first)
          )
        end

        # @param selector_type [Symbol] selector type, :css, :xpath, etc...
        # @param selector_path [String] path to element
        # @return [Array<AutomationObject::Driver::Element>] elements
        def find_elements(selector_type, selector_path)
          elements = self.get_elements(selector_type, selector_path)
          return elements.map { |element|
            AutomationObject::Driver::Element.new(
              AutomationObject::Driver::NokogiriAdapter::Element.new(driver: self, element: element)
            )
          }
        end

        #Accept prompt either in browser or mobile
        def accept_prompt
        end

        #Dismiss the prompt
        def dismiss_prompt
        end

        # Check if browser, more useful for Appium but can be generic here
        # @return [Boolean] whether or not browser is being used
        def is_browser?
          true
        end

        #Window Handles
        # @return [Array<String>] array of window handle ids
        def window_handles
          self.session.window_handles
        end

        #Current window handle
        # @return [String] handle id
        def window_handle
          self.session.window_handle
        end

        #Set current window handle to, will switch windows
        # @param handle_value [String] window handle value
        def window_handle=(handle_value)
          self.session.window_handle = handle_value
        end

        # Run script in browser to check if document in JS is complete
        # @return [Boolean] document is complete
        def document_complete?
        end

        # Wait till the document is complete
        # @return [void]
        def document_complete_wait
        end

        # @param script [String] JS to run
        # @return [Object, nil]
        def execute_script(script)
        end

        # @return [Point] x,y scroll position
        def scroll_position
          Point.new(x: 0, y: 0)
        end

        # @return [Float] inner window height
        def inner_window_height
          0
        end

        # Destroy the driver
        def quit
          self.session.quit
        end

        protected

        def get_elements(selector_type, selector_path)
          case selector_type
            when :xpath
              elements = self.session.xml.xpath(selector_path)
            when :css
              elements = self.session.xml.css(selector_path)
            else
              raise ArgumentError, "#{selector_type} selector type not implemented. Only :css, :xpath"
          end

          return elements
        end
      end
    end
  end
end