
Feature: List capabilities
 List the dry run capabilities

  Scenario: List caps browserstack
    When I run `cloudtest list-caps browserstack`
    Then the output should contain "key"
    Then the output should contain "browserstack.local"

  Scenario: List caps lambdatest
    When I run `cloudtest list-caps lambdatest`
    Then the output should contain "key"
    Then the output should contain "tunnel"

  Scenario: List caps saucelabs
    When I run `cloudtest list-caps sl`
    Then the output should contain "key"
    Then the output should contain "takesScreenshot"

  Scenario: List caps crossbrowsertesting
    When I run `cloudtest list-caps crossbrowsertesting`
    Then the output should contain "key"
    Then the output should contain "record_video"