require_relative 'core'
class Crossbrowsertesting < Core

  SERVER = 'hub.crossbrowsertesting.com/wd/hub'
  def self.init
    @config = load_config('CBT_USERNAME', 'CBT_ACCESS_KEY')

    Capybara.app_host = 'http://local:80'
    puts '> Running features on crossbrowsertesting.com'
    @caps = Hash.new

    @caps['max_duration'] = '1200'
    @caps['record_video'] = 'true'
    @caps['record_network'] = 'true'
    @caps["javascriptEnabled"] = true
    @caps["webStorageEnabled"] = true
    @caps["acceptSslCerts"] = true


    @caps['platform'] = ENV['CLOUDTEST_PLATFORM'].to_s << ENV['CLOUDTEST_OS'].to_s || 'WINDOWS 10'
    @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'

    @caps = merge_caps(@caps, @config)

  end
  def self.start
    register_driver(@caps, @config['user'], @config['key'], SERVER)
    # maybe add tunnel
  end
  if enabled
    init()
    start()
  end

  def self.list_caps # defaults
    Core.list_caps
    puts "Crossbrwosertesting specific ENV variables:"
    puts "ENV['CBT_USERNAME']"
    puts "ENV['CBT_ACCESS_KEY']"
    puts 'You can find all available caps https://help.crossbrowsertesting.com/selenium-testing/tutorials/crossbrowsertesting-automation-capabilities/'
  end

  def self.get_all_caps # dry run
    @caps.kind_of?(Hash) || init()
    puts "Capabilities: "
    list_these_caps(@caps)
  end
end


