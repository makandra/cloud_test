module Cloudtest

  class Crossbrowsertesting
    if Cloudtest::Cloudtest_Core.enabled
      Capybara.app_host = 'http://local:80'
      puts 'Running features on crossbrowsertesting.com'

      TASK_ID = (ENV['TASK_ID'] || 0).to_i

      CONFIG = Cloudtest::Cloudtest_Core.load_config('CBT_USERNAME', 'CBT_ACCESS_KEY')
      SERVER = 'hub.crossbrowsertesting.com/wd/hub'
      @caps = Hash.new
      @caps['max_duration'] = '1200'
      @caps['record_video'] = 'true'
      @caps['record_network'] = 'true'
      @caps["javascriptEnabled"] = true
      @caps["webStorageEnabled"] = true
      @caps["acceptSslCerts"] = true


      @caps['platform'] = ENV['CLOUDTEST_PLATFORM'].to_s << ENV['CLOUDTEST_OS'].to_s || 'WINDOWS 10'
      @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'

      @caps = Cloudtest::Cloudtest_Core.merge_caps(@caps, CONFIG)

      Cloudtest::Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)
    end

    def list_caps
      Cloudtest::Cloudtest_Core.list_caps
      puts 'You can find all available caps https://help.crossbrowsertesting.com/selenium-testing/tutorials/crossbrowsertesting-automation-capabilities/'
    end

    def self.get_all_caps
      puts "I am using the following capabilities:\n"
      Cloudtest_Core.list_these_caps(@caps)
    end
  end
end

