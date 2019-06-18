require_relative 'core'
class Browserstack < Core
  # do anything browserstack specific
  SERVER = "hub-cloud.browserstack.com/wd/hub"
  ENV_USER ='BROWSERSTACK_USERNAME'
  ENV_PWD = 'BROWSERSTACK_ACCESS_KEY'
  @config = Hash.new
  def self.init
    @config = Core.load_config(ENV_USER, ENV_PWD)
    puts "key: " + @config['key']

    @caps = Hash.new

    @caps['os_version'] = ENV['CLOUDTEST_OS'] || '10'
    @caps['os'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
    @caps['browser'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'
    @caps['browser_version'] = ENV['CLOUDTEST_BROWSER_VERSION']

    @caps["browserstack.local"] = true
    @caps["browserstack.debug"] = true # Visual log
    @caps["acceptSslCerts"] = true # allow self signed certificates

    @caps = Core.merge_caps(@caps, @config)
    Capybara.app_host = "http://127.0.0.1:45693"
    Capybara.server_port = 45693
  end

  def self.start
    puts '> Running features on browserstack.com'
    begin
      require 'browserstack/local'
    rescue LoadError
      puts 'Please add gem "browserstack-local" to your gemfile!'
      raise LoadError
    end
    # Code to start browserstack local before start of test
    @bs_local = BrowserStack::Local.new
    puts "key: " + @config['key']
    bs_local_args = {"key" => "#{@config['key']}"}
    #@bs_local.start(bs_local_args)
    register_driver(@caps, @config['user'], @config['key'], SERVER)

    # Code to stop browserstack local after end of test
    at_exit do
      @bs_local.stop unless @bs_local.nil?
    end
  end

  if Core.enabled
    self.init()
    self.start()
  end

  def self.list_caps # defaults
    Core.list_caps
    puts "browserstack specific ENV variables:"
    puts "ENV['BROWSERSTACK_USERNAME']"
    puts "ENV['BROWSERSTACK_ACCESS_KEY']"
    puts 'you can generate capabilities here https://www.browserstack.com/automate/capabilities?tag=selenium-4'
  end

  def self.get_all_caps # dry run
    @caps.kind_of?(Hash) || init()
    puts "Capabilities: "
    Core.list_these_caps(@caps)
  end
end