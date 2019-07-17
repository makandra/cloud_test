require 'thor'
require 'cloud_test/generators/config'
require 'cloud_test/generators/cloud_test_env'
require_relative 'browserstack'
require_relative 'lambdatest'
require_relative 'cross_browser_testing'
require_relative 'saucelabs'


module CloudTest
  class CLI < Thor
    desc "list-caps PROVIDER", "Shows the currently applied capabilities of that provider"
    def list_caps(provider)
      hash = {"provider" => provider}
      Core.get_provider_class(hash).get_all_caps
    end

    desc "list-default-caps PROVIDER", "Shows the default capabilities for that provider"
    def list_default_caps(provider)
      hash = {"provider" => provider}
      Core.get_provider_class(hash).list_caps
    end

    desc "generate config", "Puts a sample config yml file into /config directory"
    def generate_config(config)
      CloudTest::Generators::Config.start([config])
    end

    desc "generate", "Puts a sample config yml file into /config directory"
    def generate()
      CloudTest::Generators::Config.start()
      CloudTest::Generators::Support.start()
    end

    desc "start", "Runs cucumber sequentially for all defined browsers. Uses the cucumber tag. With -v redirect all the standard output"
    option :v
    def start()
      require 'open3'
      config = Core.load_config
      config['browsers'].keys.each { |browser_config_name|
        Open3.popen2e({'CLOUD_TEST' =>browser_config_name.to_s}, "bundle" ,"exec", "cucumber", "-t","#{config['cucumber_tag'].to_s}") do |stdin, stdout_err, wait_thr|
          if options[:v]
            while line = stdout_err.gets
              puts line
            end
          end
          exit_status = wait_thr.value
          if exit_status == 0
            puts "Test on browser: #{browser_config_name} was successful!"
          else
            puts "Test on browser: #{browser_config_name} was not successful!"
            puts stdout_err
            raise "did not work"
          end
        end
      }
    end

    desc "test-config", "Test whether the config file is configured properly"
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
