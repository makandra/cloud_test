Feature: Generating and placing the sample config

  Scenario: Generate and copy config
    When I run `cloudtest generate config`
    Then the following files should exist:
    | config/cloud_test.yml |
    Then the file "config/cloud_test.yml" should contain:
    """
    user: "username"
    """

