require_relative '../test_helper'
require_relative '../../lib/automation_object/driver/nokogiri_adapter'

#Test AutomationObject::Driver
class TestDriver < Minitest::Test
  def setup
    #Reset Adapter
    AutomationObject::Driver.instance_variable_set(:@adapter, nil)
  end

  def teardown
  end

  def test_adapter_default
    assert_equal AutomationObject::Driver::NokogiriAdapter, AutomationObject::Driver.adapter
  end

  def test_adapter_appium
    AutomationObject::Driver.adapter = :appium
    assert_equal AutomationObject::Driver::AppiumAdapter, AutomationObject::Driver.adapter
  end

  def test_adapter_nokogiri
    AutomationObject::Driver.adapter = :nokogiri
    assert_equal AutomationObject::Driver::NokogiriAdapter, AutomationObject::Driver.adapter
  end

  def test_adapter_selenium
    AutomationObject::Driver.adapter = :selenium
    assert_equal AutomationObject::Driver::SeleniumAdapter, AutomationObject::Driver.adapter
  end
end