require_relative 'proxies/proxy'
require_relative 'blue_print'
require_relative 'driver'
require_relative 'dsl'
require_relative 'state'

module AutomationObject
  #Framework class, the core
  #A Proxy class that will become the DSL Framework
  class Framework < Proxies::Proxy
    #Static
    class << self
      attr_accessor :singleton

      #Singleton method if using Cucumber
      #TODO: was temporary fix for Cucumber, probably change
      # @return [Framework] singleton of self
      def get
        return self.singleton
      end
    end

    attr_accessor :args, :blue_prints, :driver, :state, :dsl

    # @param args [Hash] arguments for Framework
    # Example:
    # args = {
    #   :blue_print_type => :yaml,
    #   :blue_prints => '/path/to/yaml/directory',
    #   :driver_type => :selenium,
    #   :driver => selenium_object
    # }
    def initialize(args={})
      args.symbolize_keys_deep!
      self.args = args

      #Create the DSL
      #Should create all subsequent needed object
      @subject = self.dsl

      AutomationObject::Framework.singleton = self
    end

    # dsl get method
    # @return [Dsl] workable dsl composite object
    def dsl
      @dsl ||= Dsl.new(blue_prints: self.blue_prints, state: self.state)
    end

    # state get method
    # @return [State] state object which actively controls the ui state
    def state
      @state ||= State.new(self.blue_prints, self.driver)
    end

    # BluePrints (UI configurations) wrapped in an composite
    # Composite provides a common interface for all adapters
    # Under AutomationObject::BluePrint::Composite::
    # @return [AutomationObject::BluePrint::Composite::Top] top composite object
    def blue_prints
      BluePrint.adapter = self.args.fetch(:blue_print_type, :hash)
      @blue_prints ||= BluePrint.new(self.args.fetch(:blue_prints, {}))
    end

    # Driver port provides a formatted interface for interacting with different drivers
    # @return [AutomationObject::Driver::Driver] driver interface object
    def driver
      driver_type = self.args.fetch(:driver_type, nil)
      driver = self.args.fetch(:driver, nil)

      if driver_type
        Driver.adapter = driver_type
      else
        case driver
          when Selenium::WebDriver::Driver
            Driver.adapter = :selenium
          when Appium::Driver
            Driver.adapter = :appium
          else
            Driver.adapter = :nokogiri
        end
      end

      @driver ||= Driver.new(driver)
    end

    #Reset the entire state, remove any values
    #Leave the driver alone here, can be done elsewhere
    def quit
      self.state.quit #Quit the state.  That way it knows to kill threads if operational

      @dsl = nil
      @state = nil
      @blue_prints = nil
      @driver = nil
    end
  end
end