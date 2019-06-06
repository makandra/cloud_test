require 'selenium/webdriver'
require 'capybara'
require 'yaml'

class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    if @browser
      @browser.navigate.to('about:blank')
    end
  end
end
class Cloudtest_Core
  CONFIG_NAME = ENV['CONFIG_NAME'] || 'cloudtest'
  def self.enabled
    if ENV['CLOUDTEST']
      puts 'You have enabled CloutTest!'
    end
  end

  def self.loadConfig
    begin
      config = YAML.load(File.read(File.join(File.dirname(__FILE__), "../../config/#{CONFIG_NAME}.config.yml")))
    rescue
      puts 'Error: I need a config yml file, named ENV["CONFIG_NAME"] or "cloudtest" which has at least a "user" and and "key" pair, thank you!'
    else
      return config
    end
  end

  def self.register_driver(capsArray, user, key, server)
    Capybara.register_driver :cloudtest do |app|

      Capybara::Selenium::Driver.new(app,
                                     :browser => :remote,
                                     :url => "https://#{user}:#{key}@#{server}",
                                     :desired_capabilities => capsArray
      )
      Capybara.default_driver = :cloudtest
      end
  end

end
