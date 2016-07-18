module AutomationObject
  module State
    class UndefinedLoadTypeError < StandardError; end

    class NoInitialScreenError < StandardError
      def initialize(message = 'No initial screen to be set to')
        super
      end
    end

    class ScreenNotActiveError < StandardError
      def initialize(screen)
        message = "#{screen} is not currently active"
        super(message)
      end
    end
  end
end