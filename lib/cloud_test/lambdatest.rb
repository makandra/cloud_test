require_relative 'core'

module CloudTest
  class Lambdatest < Core
    SERVER = 'hub.lambdatest.com/wd/hub'
    DASHBOARD_LINK = "https://automation.lambdatest.com/"
    def self.init(config=nil)
      @config = config || load_config('LT_USERNAME', 'LT_ACCESS_KEY')
      @caps = Core.get_default_caps
      @caps['tunnel'] = true
      @caps['visual'] = true
      @caps['javascriptEnabled'] = true
      @caps['webStorageEnabled'] = true
      @caps['acceptSslCerts'] = true
      @caps['acceptInsecureCerts'] = true
      @caps['network'] = true


      @caps['os']          = '10'
      @caps['platform']    = 'WINDOWS'
      @caps['browserName'] = 'CHROME'
      @caps['version']     = '72'


      @caps = merge_caps(@caps, @config, 'lambdatest')
      if !config.nil?
        start()
      end
    end
    def self.start
      puts '> Running features on lambdatest.com'

      register_driver(@caps, @config['user'], @config['key'], SERVER)
      Capybara.app_host = 'https://localhost.lambdatest.com:4504'
      Capybara.server_port = 4504
      puts 'Capybara.app_host = "https://localhost.lambdatest.com:4504"'

    end


    def self.list_caps
      Core.list_caps
      puts "Lambdatest specific defaults:"
      puts "\ttunnel: true"
      puts "\tvisual: true"
      puts "\tjavascriptEnabled: true"
      puts "\twebStorageEnabled: true"
      puts "\tacceptSslCerts: true"
      puts "\tacceptInsecureCerts: true"
      puts "\tnetwork: true"
      puts 'You can find a caps generator here: https://www.lambdatest.com/capabilities-generator/'
    end

    def self.get_all_caps
      !@caps.nil? && @caps.keys > 0 || init()
      puts "Capabilities: "
      list_these_caps @caps
    end
  end
end


