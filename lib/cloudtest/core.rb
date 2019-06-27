require 'selenium/webdriver'
require 'capybara'
require 'yaml'

class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    raise "löschbar?"
    if @browser
      @browser.navigate.to('about:blank')
    end
  end
end


# class Foo
#   class << self
#     def foo
#
#     end
#
#     private
#
#     def bar
#
#     end
#   end
# end
#
# Foo.foo
# Foo.bar
#
# class String
#   def double_size
#     2 * size
#   end
# end
#
#
# x = "foo"
# x.size # => 3
#
# def x.double_size
#   2 * size
# end
#
# x.double_size # => 6
#
# y = "foo"
#
#


module CloudTest
  class Core
    CONFIG_NAME = 'cloud_test'
    def self.enabled
      en = ENV.has_key?('CLOUD_TEST')
      if en
        puts 'You have enabled CloudTest!'
      else
        puts 'To enable CloutTest please set the CLOUD_TEST env variable to "chrome".'
      end
      return en
    end

      def self.load_config(env_user='CLOUD_TEST_USER', env_pw='CLOUD_TEST_PW')
        config = Hash.new
        @caps = Hash.new
        @caps['project'] = ENV['CLOUDTEST_PROJECT'] || File.split(Dir.getwd)[-1] # folder name
        @caps['build'] = ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
        @caps['name'] = ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message

        path = `pwd`.to_s.gsub(/\s+/, "") + "/config/#{CONFIG_NAME}.yml"
        begin
          config = YAML.load_file(File.absolute_path path)
          if ENV.has_key?(env_user) && ENV.has_key?(env_pw)
          config['key'] = ENV[env_pw]
          config['user'] = ENV[env_user]
          end
        rescue SystemCallError
          begin
            config = YAML.load_file(File.absolute_path('/home/philipp/RubymineProjects/cloudtest' + "/config/#{CONFIG_NAME}.yml")) #TODO: remove in the future
          rescue SystemCallError #error, most likely no config file
              puts 'Error: no config file found at: ' + path
              puts 'Tip: You should run your tests from your main project directory'
              puts 'Error: I need a config yml file, named ENV["CONFIG_NAME"] or "cloud_test.yml" which has at least a "user" and and "key" pair, thank you!'
          end
        else
          if config.has_key?('user') && config.has_key?('key') && config.has_key?('provider')
            return merge_caps(@caps, config)
          else
            puts 'Error: I have a config yml file, but no user, key or provider value :('
            puts "Keys: " + config.keys.to_s
          end

        end
      end

      def self.register_driver(capsArray, user, key, server)
        Capybara.register_driver :cloud_test do |app|
          Capybara::Selenium::Driver.new(app,
                                         :browser => :remote,
                                         :url => "https://#{user}:#{key}@#{server}",
                                         :desired_capabilities => capsArray
          )
        end

      end

      def self.list_caps
        puts 'You can configure all the env variables below:' + """\n
      ENV['CLOUDTEST_PROJECT'] || # name of the folder
      ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
      ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message
      ENV['CLOUDTEST_OS'] || '10'
      ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
      ENV['CLOUDTEST_BROWSER'] || 'CHROME'"""
        puts 'Please add additional capabilities in the cloud_test.yml file'
      end

      def self.list_these_caps(caps)
        if caps.kind_of?(Enumerable)
          caps.each do |key, value|
            puts "|#{key.to_s.ljust(25)}|#{value.to_s.ljust(44)}|\n"
          end
        else
          puts "Error: No caps"
        end
      end

      private
      def self.copy_keys(caps, config, keys=config.keys)
        keys.each do |key|
          #if config[key].kind_of?(String) || config[key].kind_of?(TrueClass) || config[key].kind_of?(FalseClass) # only copy string, true or false
          # provider specific hashes don't matter, they get ignored as long as they stay hashes
          caps[key] = config[key]
          #end
        end
      end

      public
      def self.merge_caps(caps, config, provider=nil, browser=ENV['CLOUD_TEST']) # config overwrites in case of conflict
        if !config.kind_of?(Hash)
          return caps
        end
        keys = config.keys - ['common_caps', 'browser_caps'] # handle those seperatly
        copy_keys caps, config, keys
        if provider && config.has_key?(provider) && config[provider].class.included_modules.include?(Enumerable) # unpack browser specific capabilities
          puts "found specific values for provider!"
          copy_keys caps, config[provider]
        end
        if config.has_key?('common_caps')
          caps = caps.merge(config['common_caps'])
        end
        if config.has_key?('browser_caps')
          if config['browser_caps'].kind_of?(Hash) # be more polite, allow browserstack notation and allow missing dash
            caps = caps.merge(config['browser_caps'][browser || 0])
          else
            caps = caps.merge(config['browser_caps'])
          end
        end
        return caps
      end
    end
end
