# frozen_string_literal: true

require_relative '../../test_helper'

# Test AutomationObject::BluePrint::YamlAdapter
class TestYamlHashAdapter < Minitest::Test
  def setup
    AutomationObject::BluePrint.adapter = :yaml
    AutomationObject::BluePrint::HashAdapter::Top.skip_validations = true

    @yaml_adapter = AutomationObject::BluePrint::YamlAdapter.build
  end

  def teardown
    AutomationObject::BluePrint.adapter = :hash
    AutomationObject::BluePrint::HashAdapter::Top.skip_validations = false
  end

  def test_new
    assert_instance_of AutomationObject::BluePrint::Composite::Top, @yaml_adapter
  end
end
