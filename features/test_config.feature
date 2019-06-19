Feature: Check wether the config is accepted

  Scenario: Config check
    When I run `cloudtest test config`
    Then the following files should exist:
      | config/cloud_test.yml |
    Then the output should contain "Successfull"
