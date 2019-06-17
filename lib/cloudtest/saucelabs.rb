module Cloudtest
  class Lambdatest
    if Cloudtest::Cloudtest_Core.enabled

      puts '> Running features on saucelabs.com'

      TASK_ID = (ENV['TASK_ID'] || 0).to_i

      CONFIG = Cloudtest::Cloudtest_Core.load_config
      CONFIG['user'] = ENV['SL_USERNAME'] || CONFIG['user']
      CONFIG['key'] = ENV['SL_ACCESS_KEY'] || CONFIG['key']
      SERVER = 'ondemand.saucelabs.com:443/wd/hub'
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

      @caps['project'] = ENV['CLOUDTEST_PROJECT'] || File.split(Dir.getwd)[-1]
      @caps['build'] = ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
      @caps['name'] = ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message

      @caps['os'] = ENV['CLOUDTEST_OS'] || '10'
      @caps['platform'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
      @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'

      @caps = Cloudtest::Cloudtest_Core.merge_caps(@caps, CONFIG)


      puts 'starting saucelabs tunnel..'
       # inpsire solution by browserstack for starting the tunnel `bin/saucelabs_tunnel -u 7kQU -k 9eee597f-4615-4d10-b9a8-706fb7e75974`
      Cloudtest::Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)
    end

    def self.list_caps
      Cloudtest::Cloudtest_Core.list_caps
      puts 'You can find a caps generator here: https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/'
    end

    def self.get_all_caps
      puts @caps
    end
  end
end

