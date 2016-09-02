require_relative 'support/parse'

# Screen related step definitions
#
# Warning: Examples documentation is parsed and turned into unit tests checked the step definition regex
# This is to make sure that the examples in the docs will actually perform as indicated
# Please follow what is already defined below

# Close the given or current screen
#
# Examples:
# - I close the "contact" screen
# - I close the screen
# - I destroy the screen
Then(/^I (?:close|destroy) the ("([\w\s]+|%\{[\w\d]+\})")? ?screen$/) do |*args|
  unparsed_name, name = AutomationObject::StepDefinitions::Parse.new(args).get

  if name
    AutomationObject::Framework.get.screen(name).close
  else
    AutomationObject::Framework.get.current_screen.close
  end
end

# Navigate back on a given or current screen
#
# Examples:
# - I navigate back on the screen
# - I navigate back on the "contact" screen
Then(/^I (?:navigate|go) back (?:on )?(?:the )?("([\w\s]+|%\{[\w\d]+\})")? ?screen$/) do
  unparsed_name, name = AutomationObject::StepDefinitions::Parse.new(args).get

  if name
    AutomationObject::Framework.get.screen(name).back
  else
    AutomationObject::Framework.get.current_screen.back
  end
end

# Switch/Focus screen
#
# Examples:
# - I switch to the "home" screen
# - I focus the "contact" screen
Then(/^I (?:switch|focus) (?:to )?(?:the )?"([\w\s]+|%\{[\w\d]+\})" screen$/) do |*args|
  screen = AutomationObject::StepDefinitions::Parse.new(args).get
  AutomationObject::Framework.get.focus(screen)
end

# Set the current screen's width or given screen
#
# Examples:
# - I set the screen size to 1000x2000
# - I set the "home" screen size to 1000x2000
# - I set the screen width to 1000
# - I set the screen height to 2000
Then(/^I set the ("([\w\s]+|%\{[\w\d]+\})")? ?screen (size|width|height) to (\d+|(\d+)x(\d+))$/) do |*args|
  unparsed_screen, screen, dimension, size, width, height = AutomationObject::StepDefinitions::Parse.new(args).get

  if screen
    screen = AutomationObject::Framework.get.screen(screen)
  else
    screen = AutomationObject::Framework.get.current_screen
  end

  case
    when width and height
      screen.size(width.to_i, height.to_i)
    when dimension == 'width' and size
      screen.width(size)
    when dimension == 'height' and size
      screen.height(size)
  end
end