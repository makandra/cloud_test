
Feature: List default capabilities
 List the default capabilities

  Scenario: List default caps browserstack
    When I run `cloudtest list-default-caps bs`
    Then the output should contain "ENV['CLOUDTEST_OS'] || '10'"
    Then the output should contain "ENV['BROWSERSTACK_USERNAME']"

  Scenario: List default caps lambdatest
    When I run `cloudtest list-default-caps lt`
    Then the output should contain "ENV['CLOUDTEST_OS'] || '10'"
    Then the output should contain "ENV['LT_ACCESS_KEY']"

  Scenario: List default caps saucelabs
    When I run `cloudtest list-default-caps sauce`
    Then the output should contain "ENV['CLOUDTEST_OS'] || '10'"
    Then the output should contain "ENV['SL_USERNAME']"

  Scenario: List default caps crossbrowsertesting
    When I run `cloudtest list-default-caps cbt`
    Then the output should contain "ENV['CLOUDTEST_OS'] || '10'"
    Then the output should contain "ENV['CBT_USERNAME']"