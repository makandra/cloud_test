require 'cloud_test'

if CloudTest.enabled?
  Before do
    Capybara.current_driver = :cloud_test
  end
end
