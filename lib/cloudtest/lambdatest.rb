require_relative 'core'
class Lambdatest < Core
  SERVER = 'hub.lambdatest.com/wd/hub'

  def self.init
    @config = load_config('LT_USERNAME', 'LT_ACCESS_KEY')
    @caps = Hash.new
    @caps['tunnel'] = 'true'
    @caps['visual'] = 'true'
    @caps['javascriptEnabled'] = 'true'
    @caps['webStorageEnabled'] = 'true'
    @caps['acceptSslCerts'] = 'true'


    @caps['os'] = ENV['CLOUDTEST_OS'] || '10'
    @caps['platform'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
    @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'
    @caps['version'] = ENV['CLOUDTEST_BROWSER'] || '69'


    @caps = merge_caps(@caps, @config)

  end
  def self.start
    puts '> Running features on lambdatest.com'

    register_driver(@caps, @config['user'], @config['key'], SERVER)
    Capybara.app_host = 'http://localhost:4504'
    Capybara.server_port = 4504
  end
  if enabled
    init()
    start()
  end

  def self.list_caps
    Core.list_caps
    puts "Lambdatest specific ENV variables:"
    puts "ENV['LT_USERNAME']"
    puts "ENV['LT_ACCESS_KEY']"
    puts 'You can find a caps generator here: https://www.lambdatest.com/capabilities-generator/'
  end

  def self.get_all_caps
    @caps.kind_of?(Hash) || init()
    puts "Capabilities: "
    list_these_caps @caps
  end
end


