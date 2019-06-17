module Cloudtest
  class Lambdatest
    if Cloudtest::Cloudtest_Core.enabled

      puts '> Running features on lambdatest.com'

      TASK_ID = (ENV['TASK_ID'] || 0).to_i

      CONFIG = Cloudtest::Cloudtest_Core.load_config('LT_USERNAME', 'LT_ACCESS_KEY')

      SERVER = 'hub.lambdatest.com/wd/hub'
      @caps = Hash.new
      @caps['tunnel'] = 'true'
      @caps['visual'] = 'true'
      @caps['javascriptEnabled'] = 'true'
      @caps['webStorageEnabled'] = 'true'
      @caps['acceptSslCerts'] = 'true'


      @caps['os'] = ENV['CLOUDTEST_OS'] || '10'
      @caps['platform'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
      @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'

      @caps = Cloudtest::Cloudtest_Core.merge_caps(@caps, CONFIG)

      Cloudtest::Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)
    end

    def self.list_caps
      Cloudtest::Cloudtest_Core.list_caps
      puts 'You can find a caps generator here: https://www.lambdatest.com/capabilities-generator/'
    end

    def self.get_all_caps
      puts @caps
    end
  end
end

