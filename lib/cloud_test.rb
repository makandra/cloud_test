require "cloud_test/version"
require "cloud_test/core"


module CloudTest
  class Error < StandardError; end
  def self.enabled?
    ENV.has_key?('CLOUD_TEST')
  end
  if enabled?
    config = Core.load_config
    case config.delete('provider').to_s.downcase
    when 'browserstack'
      require 'cloud_test/browserstack'
      Browserstack.init config
    when 'lambdatest'
      require 'cloud_test/lambdatest'
      Lambdatest.init config
    when 'crossbrowsertesting'
      require 'cloud_test/cross_browser_testing'
      CrossBrowserTesting.init config
    when 'saucelabs', 'sauce'
      require 'cloud_test/saucelabs'
      Saucelabs.init config
    else
      puts "Error: Please add a valid provider to your config file!"
    end
  end
end
