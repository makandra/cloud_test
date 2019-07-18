require_relative 'core'
module CloudTest
  class Saucelabs < Core
    SERVER = 'ondemand.saucelabs.com:443/wd/hub'
    DASHBOARD_LINK = "https://app.saucelabs.com/dashboard/builds"
    def self.init(config=nil)
      @config = config || load_config('SL_USERNAME', 'SL_ACCESS_KEY')

      @caps = Core.get_default_caps
      @caps['record_video'] = true
      @caps['record_network'] = true
      @caps['javascriptEnabled'] = true
      @caps['acceptSslCerts'] = true
      @caps['webStorageEnabled'] = true
      @caps['cssSelectorsEnabled'] = true
      @caps['takesScreenshot'] = true


      @caps['platform']    = 'WINDOWS 10'
      @caps['browserName'] = 'CHROME'

      Capybara.app_host = "http://0.0.0.0:4594"
      Capybara.server_port = 4594

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
    end

    def self.list_caps
      Core.list_caps
      puts "Saucelabs specific defaults:"
      puts "\trecord_video: true"
      puts "\trecord_network: true"
      puts "\tjavascriptEnabled: true"
      puts "\tacceptSslCerts: true"
      puts "\twebStorageEnabled: true"
      puts "\tcssSelectorsEnabled: true"
      puts "\ttakesScreenshot: true"
      puts 'You can find a caps generator here: https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/'
    end

    def self.get_all_caps
      @caps.kind_of?(Hash) || init()
      puts "Capabilities: "
      list_these_caps @caps
    end
  end
end


