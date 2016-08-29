require_relative 'hook'

module AutomationObject
  module State
    #Helper module for Element composite classes
    module Composite
      module CommonElement
        def method_hook?(name)
          return self.blue_prints.method_hooks.has_key?(name)
        end

        # @return [Hash<Hook>] array of Hook that are defined under the element
        def method_hooks
          return @method_hooks if @method_hooks

          @method_hooks = {}
          self.blue_prints.method_hooks.each { |key, blue_prints|
            @method_hooks[key] = Hook.new(blue_prints,
                                          self.driver,
                                          key,
                                          self,
                                          self.location + "[#{key}]")
          }

          return @method_hooks
        end
      end
    end
  end
end

