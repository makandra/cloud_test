require "cloudtest/version"
require "cloudtest/core"


module CloudTest
  class Error < StandardError; end
  def self.enabled?
    ENV.has_key?('CLOUD_TEST')
  end
  if enabled?
    config = CloudTest::Core.load_config
    case config.delete('provider').to_s.downcase
    when 'browserstack', 'bs'
      require 'cloudtest/browserstack'
      CloudTest::Browserstack.init config
    when 'lambdatest', 'lt'
      require 'cloudtest/lambdatest'
      CloudTest::Lambdatest.init config
    when 'crossbrowsertesting', 'cbs', 'ct', 'cbt'
      require 'cloudtest/cross_browser_testing'
      CloudTest::CrossBrowserTesting.init config
    when 'saucelabs', 'sauce', 'sc', 'sl'
      require 'cloudtest/saucelabs'
      CloudTest::Saucelabs.init config
    else
      puts "Error: Please add a valid provider to your config file!"
    end
  end
end
