module Cloudtest
  class Browserstack
    # do anything browserstack specific

    if Cloudtest::Cloudtest_Core.enabled
      puts '> Running features on browserstack.com'
      begin
        require 'browserstack/local'
      rescue LoadError
        puts 'Please do a gem install browserstack-local !'
      end
      CONFIG = Cloudtest::Cloudtest_Core.load_config

      CONFIG['user'] = ENV['BROWSERSTACK_USERNAME'] || CONFIG['user']
      CONFIG['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || CONFIG['key']
      SERVER = "hub-cloud.browserstack.com/wd/hub"


      @caps['project'] = ENV['CLOUDTEST_PROJECT'] || File.split(Dir.getwd)[-1]
      @caps['build'] = ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
      @caps['name'] = ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message

      @caps['os_version'] = ENV['CLOUDTEST_OS'] || '10'
      @caps['os'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
      @caps['browser'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'
      @caps['browser_version'] = ENV['CLOUDTEST_BROWSER_VERSION']

      @caps["browserstack.local"] = true
      @caps["browserstack.debug"] = true # Visual log
      @caps["acceptSslCerts"] = true # allow self signed certificates

      @caps = Cloudtest::Cloudtest_Core.merge_caps(@caps, CONFIG)



      # Code to start browserstack local before start of test
      @bs_local = BrowserStack::Local.new
      bs_local_args = {"key" => "#{CONFIG['key']}"}
      @bs_local.start(bs_local_args)
      Cloudtest::Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)

      # Code to stop browserstack local after end of test
      at_exit do
        @bs_local.stop unless @bs_local.nil?
      end
    end

    def list_caps
      Cloudtest::Cloudtest_Core.list_caps
      puts 'you can generate capabilities here https://www.browserstack.com/automate/capabilities?tag=selenium-4'
    end

    def self.get_all_caps
      puts @caps
    end
  end
end