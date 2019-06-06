
require 'yaml'

class Lambdatest

  puts 'Running features on lambdatest.com'
  #puts 'NOTE: I need a config yml file, named ENV["CONFIG_NAME"] or "single" which has at least a "user" and and "key" pair, thank you!'


  TASK_ID = (ENV['TASK_ID'] || 0).to_i
  require './core'
  CONFIG = Cloudtest_Core.loadConfig
  CONFIG['user'] = ENV['LT_USERNAME'] || CONFIG['user']
  CONFIG['key'] = ENV['LT_ACCESS_KEY'] || CONFIG['key']
  SERVER = ENV['CLOUDTEST_SERVER'] || CONFIG['server'] || 'lambdatestserver'
   @caps = CONFIG['common_caps']

    @caps['project'] = 'ams'
    @caps['build'] = `git rev-parse HEAD` # HEAD commit hash
    @caps['name'] = `git log -1 --pretty=%B` # HEAD commit message

    @caps['os'] = ENV['CLOUDTEST_OS'] || '10'
    @caps['platform'] = ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
    @caps['browserName'] = ENV['CLOUDTEST_BROWSER'] || 'CHROME'

   Cloudtest_Core.register_driver(@caps, CONFIG['user'], CONFIG['key'], SERVER)

  end

