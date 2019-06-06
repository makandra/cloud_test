
class Browserstack
  # do anything browserstack specific
  begin
    require 'browserstack/local'
  rescue LoadError
    puts 'Please do a gem install browserstack-local.'.red
  end
  require './core'
  CONFIG = Cloudtest_Core.loadConfig

  CONFIG['user'] = ENV['BROWSERSTACK_USERNAME'] || CONFIG['user']
  CONFIG['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || CONFIG['key']
  SERVER = "hub-cloud.browserstack.com"

  @caps = CONFIG['common_caps'].merge(CONFIG['browser_caps'][TASK_ID])

    # Code to start browserstack local before start of test
  @bs_local = BrowserStack::Local.new
  bs_local_args = {"key" => "#{CONFIG['key']}"}
  @bs_local.start(bs_local_args)
  Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)

  # Code to stop browserstack local after end of test
  at_exit do
    @bs_local.stop unless @bs_local.nil?
  end
end