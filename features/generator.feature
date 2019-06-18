Feature: Generating and placing the sample config

  Scenario: Generate and copy config
    When I run `cloudtest generate config`
    Then the following files should exist:
    | config/cloudtest.config.yml |
    Then the file "config/cloudtest.config.yml" should contain:
    """
    user: "username"
    """

