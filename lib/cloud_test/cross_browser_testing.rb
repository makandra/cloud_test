require_relative 'core'
module CloudTest
  class CrossBrowserTesting < Core

    SERVER = 'hub.crossbrowsertesting.com/wd/hub'
    DASHBOARD_LINK = "https://app.crossbrowsertesting.com/"
    def self.init(config=nil)
      @config = config || load_config('CBT_USERNAME', 'CBT_ACCESS_KEY')

      Capybara.app_host = 'http://local:80'
      puts '> Running features on crossbrowsertesting.com'
      @caps = Core.get_default_caps

      @caps['record_video'] = true
      @caps['record_network'] = true
      @caps["javascriptEnabled"] = true
      @caps["webStorageEnabled"] = true
      @caps["acceptSslCerts"] = true


      @caps['platform'] = 'WINDOWS 10'
      @caps['browserName'] = 'CHROME'

      @caps = merge_caps(@caps, @config, 'crossbrowsertesting')
      if config.present?
        start()
      end
    end
    def self.start
      register_driver(@caps, @config['user'], @config['key'], SERVER)
    end
    # update status
    # https://help.crossbrowsertesting.com/selenium-testing/tutorials/updating-selenium-tests-pass-fail/


    def self.list_caps # defaults
      Core.list_caps
      puts "CrossBrowserTesting specific defaults:"
      puts "\trecord_video: true"
      puts "\trecord_network: true"
      puts "\tjavascriptEnabled: true"
      puts "\twebStorageEnabled: true"
      puts "\tacceptSslCerts: true"
      puts 'You can find all available caps https://help.crossbrowsertesting.com/selenium-testing/tutorials/crossbrowsertesting-automation-capabilities/'
    end

    def self.get_all_caps # dry run
      @caps.kind_of?(Hash) || init()
      puts "Capabilities: "
      list_these_caps(@caps)
    end
  end
end


