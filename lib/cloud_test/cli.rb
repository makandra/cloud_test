require 'thor'
require 'cloud_test/generators/config'
require_relative 'browserstack'
require_relative 'lambdatest'
require_relative 'cross_browser_testing'
require_relative 'saucelabs'


module CloudTest
  class CLI < Thor
    desc "list-caps PROVIDER", "Shows the currently applied capabilities of that provider"
    def list_caps(provider)
      case provider.to_s.downcase
      when 'browserstack', 'bs', 'b'
        puts Browserstack.get_all_caps
      when 'lambdatest', 'lt', 'l'
        puts Lambdatest.get_all_caps
      when 'crossbrowsertesting', 'cbs', 'ct', 'cbt', 'c'
        puts CrossBrowserTesting.get_all_caps
      when 'saucelabs', 'sauce', 'sc', 'sl', 's'
        puts Saucelabs.get_all_caps
      end
    end

    desc "list-default-caps PROVIDER", "Shows the default capabilities for that provider"
    def list_default_caps(provider)
      case provider.to_s.downcase
      when 'browserstack', 'bs', 'b'
        puts Browserstack.list_caps
      when 'lambdatest', 'lt', 'l'
        puts Lambdatest.list_caps
      when 'crossbrowsertesting', 'cbs', 'ct', 'cbt', 'c'
        puts CrossBrowserTesting.list_caps
      when 'saucelabs', 'sauce', 'sc', 'sl', 's'
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

    desc "test-connection", "Test whether the provider and credentials work, by connectiong to the api"
    def test_connection()
      require 'net/http'
      require 'uri'
      config = CloudTest::Core.load_config
      request, uri, request, server = Hash.new
      if config.has_key?('provider') && config.has_key?('user') && config.has_key?('key')
      case config.delete 'provider'.to_s.downcase
        when 'browserstack', 'bs', 'b'
          server = "https://www.browserstack.com/local/v1/list?auth_token=#{config['key']}&last=1"
        when 'lambdatest', 'lt', 'l'
          server = "https://api.lambdatest.com/automation/api/v1/tunnels"
          uri = URI.parse(server)
          request = Net::HTTP::Get.new(uri)
          request.basic_auth(config['user'], config['key'])
        when 'crossbrowsertesting', 'cbs', 'ct', 'cbt', 'c'
          server = "https://#{config['user']}:#{config['key']}@crossbrowsertesting.com/api/v3/tunnels"
        when 'saucelabs', 'sauce', 'sc', 'sl', 's'
          server = "https://saucelabs.com/rest/v1/#{config['user']}/tunnels"
          uri = URI.parse(server)
          request = Net::HTTP::Get.new(uri)
          request.basic_auth(config['user'], config['key'])
      else
        puts "Unknown provider!"
        return
      end
      uri ||= URI.parse(server)
      request ||= Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
      req_options = {
          use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      if response.code == '200'
        puts "Connection successful!"
      else
        puts "Connection was not successful! :("
        puts response.code
      end
      else
        puts "You have not all necessary keys in your config file. `provider`, `user`, `key` are necessary"
      end
    end
  end
end

