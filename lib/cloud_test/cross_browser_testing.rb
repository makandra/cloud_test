require_relative 'core'
module CloudTest
  class CrossBrowserTesting < Core

    SERVER = "hub.crossbrowsertesting.com/wd/hub"
    DASHBOARD_LINK = "https://app.crossbrowsertesting.com/selenium/results"
    REST_STATUS_SERVER = "https://crossbrowsertesting.com/api/v3/selenium/"

    def self.init(config=nil)
      @config = config || load_config('CBT_USERNAME', 'CBT_ACCESS_KEY')

      puts '> Running features on crossbrowsertesting.com'
      @caps = Core.get_default_caps

      @caps['record_video'] = true
      @caps['record_network'] = true
      @caps["javascriptEnabled"] = true
      @caps["webStorageEnabled"] = true
      @caps["acceptSslCerts"] = true
      @caps = merge_caps(@caps, @config, 'crossbrowsertesting')
      if @caps['browserName'] &.match?(/Chrome/i)
        @options = Selenium::WebDriver::Chrome::Options.new
        @options.add_option('w3c', false)
      end
      if !config.nil?
        start()
      end
    end

    def self.start
      Capybara.server_port ||= 5555
      Capybara.app_host = "http://lvh.me:#{Capybara.server_port}"
      register_driver(@caps, @config['user'], @config['key'], SERVER, @options)
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

    def self.get_status_msg(success, reason)
      {
          "action" => "set_score",
          "score" => success ? "pass" : "fail",
          "description" => reason
      }
    end

    def self.check_session_id(session_id)
      unless session_id =~ Regexp.new('^([0-9A-z]{32})|([0-9A-z]|-){36}$')
        raise "session_id #{session_id} is invalid!"
      end
    end

  end
end


