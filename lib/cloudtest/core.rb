require 'selenium/webdriver'
#require 'capybara'
require 'yaml'

class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    if @browser
      @browser.navigate.to('about:blank')
    end
  end
end
module Cloudtest
  class Cloudtest_Core
    CONFIG_NAME = ENV['CONFIG_NAME'] || 'cloudtest'
    def self.enabled
      en = ENV['CLOUDTEST'] == 'true' || ENV['CLOUDTEST'] == '1'
      if en
        puts 'You have enabled CloudTest!'
      else
        puts 'To enable CloutTest please set the CLOUDTEST env variable to ´true´.'
      end
      return en
    end

    def self.load_config(env_user, env_pw)
      config = Hash.new
      path = `pwd`.to_s.gsub(/\s+/, "") + "/config/#{CONFIG_NAME}.config.yml"

      begin
        file = File.read(path)
        config = YAML.load(file)
        puts config
      rescue
        if ENV.has_key?(env_user) && ENV.has_key?(env_pw)
          puts 'INFO: I did not find a cloudtest.config.yml file, I continue with ENV["' + env_user + '"].'
        else
          puts 'Error: no config file found at: ' + path
          puts 'Error: I need a config yml file, named ENV["CONFIG_NAME"] or "cloudtest.config.yml" which has at least a "user" and and "key" pair, thank you!'
        end
      else
        if config.has_key?('user') && config.has_key?('key') || (ENV.has_key?(env_user) && ENV.has_key?(env_pw))
          return config
        else
          puts 'Error: I have a config yml file, but no user or key value :('
        end
      end
    end

    def self.register_driver(capsArray, user, key, server)
      Capybara.register_driver :cloudtest do |app|
        Capybara::Selenium::Driver.new(app,
                                       :browser => :remote,
                                       :url => "https://#{user}:#{key}@#{server}",
                                       :desired_capabilities => capsArray
        )
      end
      puts 'Capybara default driver was: ' + Capybara.default_driver.to_s
      Capybara.default_driver = :cloudtest
      puts 'Capybara default driver is now: ' + Capybara.default_driver.to_s

    end

    def self.list_caps
      puts 'You can configure all the env variables below:' + """\nENV['CLOUDTEST_PROJECT'] || # name of the folder
      ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
      ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message
      ENV['CLOUDTEST_OS'] || '10'
      ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
      ENV['CLOUDTEST_BROWSER'] || 'CHROME'"""
      puts 'Please add additional capabilities in the cloudtest.config.yml file'
    end

    def self.list_these_caps(caps)
      caps.each do |key, value|
        puts "|#{key.to_s.ljust(25)}|#{value.to_s.ljust(44)}|\n"
      end
    end

    def self.merge_caps(caps, config)
      if config.has_key?('common_caps')
        caps = caps.merge(config['common_caps'])
      end
      if config.has_key?('browser_caps')
        caps = caps.merge(config['browser_caps'])
      end
      return caps
    end

  end
end
