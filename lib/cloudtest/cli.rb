require 'thor'
require 'cloudtest/generators/config'
require_relative 'browserstack'
require_relative 'lambdatest'
require_relative 'cross_browser_testing'
require_relative 'saucelabs'


module CloudTest
  class CLI < Thor
    desc "list-caps PROVIDER", "Shows the currently applied capabilities of that provider"
    def list_caps(provider)
      case provider.to_s.downcase
      when 'browserstack', 'bs'
        puts Browserstack.get_all_caps
      when 'lambdatest', 'lt'
        puts Lambdatest.get_all_caps
      when 'crossbrowsertesting', 'cbs', 'ct', 'cbt'
        puts CrossBrowserTesting.get_all_caps
      when 'saucelabs', 'sauce', 'sc', 'sl'
        puts Saucelabs.get_all_caps
      end
    end

    desc "list-default-caps PROVIDER", "Shows the default capabilities for that provider"
    def list_default_caps(provider)
      case provider.to_s.downcase
      when 'browserstack', 'bs'
        puts Browserstack.list_caps
      when 'lambdatest', 'lt'
        puts Lambdatest.list_caps
      when 'crossbrowsertesting', 'cbs', 'ct', 'cbt'
        puts CrossBrowserTesting.list_caps
      when 'saucelabs', 'sauce', 'sc', 'sl'
        puts Saucelabs.list_caps
      end
    end

    desc "generate config", "Puts a sample config yml file into /config directory"
    def generate_config(config)
      Cloudtest::Generators::Config.start([config])
    end

    desc "test config", "Test whether the config file is configured properly"
    def test(type)
      config = CloudTest::Core.load_config
      config.has_key?('provider')
    end
  end
end

