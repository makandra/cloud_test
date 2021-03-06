require 'cloud_test'

if CloudTest.enabled?
  Before do
    Capybara.current_driver = :cloud_test
  end

  After do |scenario|
    if scenario.failed?
      # this may overwrite itself with multiple fails
      CloudTest.upload_status_to_provider success: false, session_id: page.driver.browser.session_id, reason: scenario.exception
    end
    # everything that is not failed is success
    # CloudTest.upload_status_to_provider success: true, session_id: page.driver.browser.session_id
  end
end
