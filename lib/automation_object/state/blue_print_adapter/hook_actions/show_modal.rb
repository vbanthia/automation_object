require_relative 'action_loop'

module AutomationObject
  module State
    module BluePrintAdapter
      class ShowModal < ActionLoop
        def initialize(args = {})
          super
          @new_modal_name = args.fetch :blue_prints
        end

        def single_run
          self.driver.document_complete_wait

          new_modal = self.composite.screen.modals[@new_modal_name]
          if new_modal.load.live?
            self.composite.screen.active_modal = new_modal
            return true
          else
            return false
          end
        end
      end
    end
  end
end