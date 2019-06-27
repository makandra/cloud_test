require_relative 'core'
module CloudTest
  class Saucelabs < Core
    SERVER = 'ondemand.saucelabs.com:443/wd/hub'

    def self.init(config=nil)
      @config = config || load_config('SL_USERNAME', 'SL_ACCESS_KEY')

      @caps = Hash.new
      @caps['record_video'] = 'true'
      @caps['record_network'] = 'true'
      @caps['javascriptEnabled'] = 'true'
      @caps['acceptSslCerts'] = 'true'
      @caps['webStorageEnabled'] = 'true'
      @caps['cssSelectorsEnabled'] = 'true'
      @caps['takesScreenshot'] = 'true'

      @caps['max_duration'] = '1200'
      @caps['javascriptEnabled'] = 'true'
      @caps['webStorageEnabled'] = 'true'
      @caps['acceptSslCerts'] = 'true'
      @caps['extendedDebugging'] = 'true'

      @caps['platform'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS 10'
      @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'


      @caps = merge_caps(@caps, @config, 'saucelabs')
      if config
        start()
      end
    end
    def self.start
      puts '> Running features on saucelabs.com'
      #puts 'starting saucelabs tunnel..'
      # inpsire solution by browserstack for starting the tunnel `bin/saucelabs_tunnel -u 7kQU -k 9eee597f-4615-4d10-b9a8-706fb7e75974`
      register_driver(@caps, @config['user'], @config['key'], SERVER)
      Capybara.app_host = 'http://web:4503'
      Capybara.server_port = 4503
    end

    def self.list_caps
      Core.list_caps
      puts "Saucelabs specific ENV variables:"
      puts "ENV['SL_USERNAME']"
      puts "ENV['SL_ACCESS_KEY']"
      puts "ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS 10'"
      puts 'You can find a caps generator here: https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/'
    end

    def self.get_all_caps
      @caps.kind_of?(Hash) || init()
      puts "Capabilities: "
      list_these_caps @caps
    end
  end
end


