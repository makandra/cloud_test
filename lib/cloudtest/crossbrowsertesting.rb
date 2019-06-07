module Cloudtest

  class Crossbrowsertesting
    if Cloudtest::Cloudtest_Core.enabled

      puts 'Running features on crossbrowsertesting.com'

      TASK_ID = (ENV['TASK_ID'] || 0).to_i

      CONFIG = Cloudtest::Cloudtest_Core.load_config
      CONFIG['user'] = ENV['LT_USERNAME'] || CONFIG['user']
      CONFIG['key'] = ENV['LT_ACCESS_KEY'] || CONFIG['key']
      SERVER = 'hub.crossbrowsertesting.com/wd/hub'

      @caps['max_duration'] = 1200
      @caps['record_video'] = 'true'
      @caps['record_network'] = 'true'
      @caps["javascriptEnabled"] = true
      @caps["webStorageEnabled"] = true
      @caps["acceptSslCerts"] = true

      @caps['project'] = ENV['CLOUDTEST_PROJECT'] || `pwd`
      @caps['build'] = ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
      @caps['name'] = ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message

      @caps['platform'] = ENV['CLOUDTEST_PLATFORM'] + ENV['CLOUDTEST_OS'] || 'WINDOWS 10'
      @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'

      @caps = @caps.merge(CONFIG['common_caps'].merge(CONFIG['browser_caps'][0]))

      Cloudtest::Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)
    end

    def list_caps
      Cloudtest::Cloudtest_Core.list_caps
      puts 'You can find all available caps https://help.crossbrowsertesting.com/selenium-testing/tutorials/crossbrowsertesting-automation-capabilities/'
    end
  end
end

