require 'selenium/webdriver'
require 'capybara'
require 'yaml'

module CloudTest
  class Core
    CONFIG_NAME = 'cloud_test'

    def self.get_default_caps
      @caps = Hash.new
      @caps['project'] = File.split(Dir.getwd)[-1] # folder name
      @caps['build'] =   `git rev-parse HEAD || echo buildname` # HEAD commit hash
      @caps['name'] =    `git log -1 --pretty=%B || echo testname` # HEAD commit message
      return @caps
    end

    def self.check_if_input_is_valid?(str)
      #for all relevant config user input only allow an optional '@' for the cucumber_tag, then some letters, followed by
      # optional digits
      # this should enhance security
      Regexp.new('^@?[A-z]+\d*$') =~ str
    end

    # the optional parameter could be deleted, or used if someone does not want to put there credentials in the config
    def self.load_config(env_user='CLOUD_TEST_USER', env_pw='CLOUD_TEST_PW')
      config = Hash.new

      @caps = self.get_default_caps
      path = `pwd`.to_s.gsub(/\s+/, "") + "/config/#{CONFIG_NAME}.yml" # complete path to the config file
      begin
        config = YAML.load_file(File.absolute_path path)
        if ENV.has_key?(env_user) && ENV.has_key?(env_pw)
          config['key'] = ENV[env_pw]
          config['user'] = ENV[env_user]
        end
      rescue SystemCallError
        puts 'Error: no config file found at: ' + path
        puts 'Tip: You should run your tests from your main project directory'
        puts 'Error: I need a config yml file, named ENV["CONFIG_NAME"] or "cloud_test.yml" which has at least a "user" and and "key" pair, thank you!'
      else
        if config.has_key?('user') && config.has_key?('key') && config.has_key?('provider') # check wether all the necessary keys exist
          list_to_check_input = [config['browsers'].keys, (config['cucumber_tag'] if config.has_key?('cucumber_tag')), config['provider']].flatten
          list_to_check_input.each do |str|
            if !check_if_input_is_valid?(str)
              raise "Invalid value: #{str}. Only characters followed by digits are allowed!"
            end
          end
          return config
        else
          puts 'Error: I have a config yml file, but no user, key or provider value :('
          puts "Keys: " + config.keys.to_s
        end
      end
    end

    def self.register_driver(capsArray, user, key, server)
      # some debugging options
      url =  "https://#{user.sub("@", "%40")}:#{key}@#{server}"
      if capsArray.has_key?('cloud_test_debug') and capsArray['cloud_test_debug']
        puts "Capybara.app_host = #{Capybara.app_host}"
        puts "Hub url: #{url}"
        list_these_caps capsArray
      end
        Capybara.register_driver :cloud_test do |app|
          Capybara::Selenium::Driver.new(app,
                                       :browser => :remote,
                                       :url => url,
                                       :desired_capabilities => capsArray
          )
        end
    end

    def self.list_caps # print defaults
      # this output could be reformatted
      puts 'These are the defaults:' + """
      PROJECT : # name of the folder
      BUILD :  # HEAD commit hash
      NAME : # HEAD commit message
      OS : '10'
      PLATFORM : 'WINDOWS'
      BROWSER : 'CHROME'"""
      puts 'Please add additional capabilities in the cloud_test.yml file'
    end

    def self.list_these_caps(caps)
      if caps.kind_of?(Enumerable)
        caps.each do |key, value|
          puts "|#{key.to_s.ljust(25)}|#{value.to_s.ljust(44)}|\n" # make a nice table like layout
        end
      else
        puts "Error: No caps"
      end
    end

    def self.copy_keys(caps, config, keys=config.keys) # a small helper method, to copy keys
      keys.each do |key|
        caps[key] = config[key]
      end
    end

    def self.merge_caps(caps, config, provider=nil, browser=ENV['CLOUD_TEST']) # config overwrites in case of conflict
      if !config.kind_of?(Hash)
        return caps
      end
      keys = config.keys - ['common_caps', 'browsers'] # handle those seperatly
      copy_keys caps, config, keys
      if provider && config.has_key?(provider) && config[provider].class.included_modules.include?(Enumerable)
        copy_keys caps, config[provider]
      end
      if config.has_key?('common_caps')
        caps = caps.merge(config['common_caps'])
      end
      if config.has_key?('browsers')
        if config['browsers'].kind_of?(Hash)
          if !browser.nil? && config['browsers'][browser].nil?
            puts "There is no browser with the key:#{browser} in your config file!"
            raise "No matching browser key found!"
          end
          caps = caps.merge(config['browsers'][browser || config['browsers'].keys[0]])
        else
          caps = caps.merge(config['browsers'])
        end
      end
      return caps
    end

    def self.get_provider_class(config=load_config)
      case config.delete('provider').to_s.downcase
      when 'browserstack', 'bs', 'b'
        require 'cloud_test/browserstack'
        return Browserstack
      when 'lambdatest', 'lt', 'l'
        require 'cloud_test/lambdatest'
        return Lambdatest
      when 'crossbrowsertesting', 'cbs', 'ct', 'cbt', 'c'
        require 'cloud_test/cross_browser_testing'
        return CrossBrowserTesting
      when 'saucelabs', 'sauce', 'sc', 'sl', 's'
        require 'cloud_test/saucelabs'
        return Saucelabs
      else
        puts "Error: Please add a valid provider to your config file!"
      end
    end

    def self.list_dashboard_link
      puts "link to the dashboard: #{get_provider_class::DASHBOARD_LINK}"
    end

    def self.upload_status(success:, session_id:, reason: "Unknown")
      config = load_config
      provider = get_provider_class config
      provider.check_session_id session_id
      puts session_id
      unless provider::REST_STATUS_SERVER.present?
        puts "skipping upload, not implementet for your provider yet."
        return
      end
      require 'net/http'
      require 'uri'
      require 'json'
      uri = URI.parse(provider::REST_STATUS_SERVER + session_id )
      request = Net::HTTP::Put.new(uri)
      request.basic_auth(config['user'], config['key'])
      request.content_type = "application/json"
      request.body = JSON.dump(provider.get_status_msg(success, reason))
      req_options = {
          use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      if response.code != '200'
        puts "Response Code: #{response.code}"
        puts "Status upload error!"
      end

    end
  end
end
