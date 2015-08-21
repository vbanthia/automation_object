module AutomationObject
  #Helper module for adding attributes/alias to classes dynamically
  #Reflection/MetaProgramming
  module ReflectionHelper
    # @param name [String, Symbol] name of attribute to add
    # @param value [Object] value of attribute
    def add_attribute(name, value)
      name = name.to_s
      alias_name = name + '?' if name.gsub!(/\?$/,'')

      self.class.send(:attr_accessor, name)
      instance_variable_set("@#{name}", value)

      self.add_alias(alias_name, name) if alias_name
    end

    # @param alias_name [Symbol, String] name of alias to add
    # @param attribute_name [Symbol, String] attribute to link to
    def add_alias(alias_name, attribute_name)
      singleton_class = class << self; self; end
      singleton_class.send(:define_method, alias_name) do
        instance_variable_get("@#{attribute_name}")
      end
    end
  end
end