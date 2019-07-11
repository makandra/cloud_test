require 'cloud_test'

if CloudTest.enabled?
  Before do
    Capybara.current_driver = :cloud_test
  end
  at_exit do
    CloudTest.show_dashboard_link
  end
end
