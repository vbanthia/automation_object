# frozen_string_literal: true
require_relative '../../error'

module AutomationObject
  module State
    module Composite
      # Window class
      class Window
        # @param window_manager [AutomationObject::State::Composite::WindowManager]
        # @param driver [AutomationObject::Driver::Driver]
        # @param handle [String]
        # @param screen [Symbol]
        def initialize(window_manager, driver, handle, screen)
          @window_manager = window_manager
          @driver = driver
          @handle = handle

          # Use to control history
          @position = 0
          @history = [screen]
        end

        # @return [Symbol,nil] previous screen name
        def previous
          return nil if @position < 1
          @history[@position - 1]
        end

        # @param name [Symbol] screen name
        # @return [void]
        def update(name)
          # Reset current screen
          @window_manager.screens[self.name].reset

          @position += 1
          @history << name
        end

        # @return [Symbol] current screen
        def name
          @history[@position]
        end

        # @return [void]
        def use
          return if @driver.window_handle == @handle
          @driver.window_handle = @handle
        end

        # @return [void]
        def back
          raise CannotNavigateBack if @position.zero?

          @driver.back
          @position -= 1
        end

        # @return [void]
        def forward
          raise CannotNavigateForward if @position >= @history.length

          @driver.forward
          @position += 1
        end

        # @return [Boolean]
        def closed?
          !@driver.window_handles.include?(window_handle)
        end

        # Close the window
        # @return [void]
        def close
          @driver.close unless closed?
        end
      end
    end
  end
end
