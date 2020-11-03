require_relative 'core'

module CloudTest
  class Browserstack < Core
    # do anything browserstack specific
    SERVER = "hub-cloud.browserstack.com/wd/hub"
    ENV_USER ='BROWSERSTACK_USERNAME'
    ENV_PWD = 'BROWSERSTACK_ACCESS_KEY'
    DASHBOARD_LINK = "https://automate.browserstack.com/dashboard"
    REST_STATUS_SERVER = "https://api.browserstack.com/automate/sessions/"

    def self.init(config=nil)
      @config = config || Core.load_config(ENV_USER, ENV_PWD)
      @caps = Core.get_default_caps

      @caps["browserstack.local"] = true
      @caps["browserstack.debug"] = true # Visual log
      @caps['os_version']      = '10'
      @caps['os']              = 'WINDOWS'
      @caps['browser']         = 'CHROME'

      @caps = Core.merge_caps(@caps, @config, 'browserstack')
      Capybara.app_host = "http://127.0.0.1:38946"
      Capybara.server_port = 38946
      if !config.nil?
        start()
      end
    end

    def self.start
      puts "> Running features on #{CloudTest::Util.colorize('browserstack.com', :light_blue)}"
      begin
        require 'browserstack/local'
      rescue LoadError
        puts 'Please add gem "browserstack-local" to your gemfile!'
        raise LoadError
      end
      # Code to start browserstack local (tunnel) before start of test
      @bs_local = BrowserStack::Local.new
      bs_local_args = {"key" => "#{@config['key']}", "logfile" => "log/browserstack-local-logs.log"}
      @bs_local.start(bs_local_args)
      register_driver(@caps, @config['user'], @config['key'], SERVER)
      # Code to stop browserstack local after end of test
      at_exit do
        @bs_local.stop unless @bs_local.nil?
      end
    end

    def self.list_caps # defaults
      Core.list_caps
      puts "Browserstack specific defaults:"
      puts "\tbrowserstack.local: true"
      puts "\tbrowserstack.debug: true "
      puts 'you can generate capabilities here https://www.browserstack.com/automate/capabilities?tag=selenium-2-3'
    end

    def self.get_all_caps # dry run
      @caps.kind_of?(Hash) || init()
      puts "Capabilities: "
      Core.list_these_caps(@caps)
    end

    def self.get_status_msg(failed, reason)
      {
          "status" => failed ? "passed" : "failed",
          "reason" => reason
      }
    end

    def self.check_session_id(session_id)
      unless session_id =~ Regexp.new('^[0-9a-z]{40}$')
        puts session_id << "length: " << session_id.length
        raise "session_id is invalid!"
      end
    end
  end
end
