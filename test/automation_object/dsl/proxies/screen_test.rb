require_relative '../../../test_helper'
require_relative '../../../../lib/automation_object/dsl/proxies/screen'

#Test AutomationObject::Dsl::Proxies::Screen
class TestDslProxyScreen < Minitest::Test
  def setup
    @proxy = AutomationObject::Dsl::Proxies::Screen.new
  end

  def teardown
  end

  def test_subject
    assert_instance_of AutomationObject::Dsl::Models::Screen, @proxy
  end

  def test_add
    test_child_stub = stub(:test_value => 'blah')
    @proxy.add(name: :test_child, object: test_child_stub, type: :test)

    assert_respond_to @proxy, :test_child
    assert_equal test_child_stub, @proxy.test_child
    assert_equal test_child_stub, @proxy[:test_child]
  end
end