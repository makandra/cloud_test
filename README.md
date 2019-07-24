# cloud_test

cloud_test enables local Cloud-Testing for a number of providers:
- Browserstack
- CrossBrowserTesting
- saucelabs
- lambdatest

The intention of this gem is to quickly enable Cloud-Testing with minimal setup required.
It assumes your are using capybara and selenium.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloud_test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloud_test
##Configuration
You can configure cloud_test in the

    config/cloud_test.yml file 
    
The minimal config includes a 'key' and a 'user' value (which may be or not be
 the login credentials for the chosen provider), as well
as 'provider' value. 
 Additional key/value pairs are possible, for example to configure the browser.

- [Browserstack Configurator](https://www.browserstack.com/automate/capabilities)
- [CrossBrowserTesting Capabilities](https://help.crossbrowsertesting.com/selenium-testing/getting-started/crossbrowsertesting-automation-capabilities/)
- [Saucelabs Configurator](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/)
- [lambdatest Capability Generator](https://www.lambdatest.com/capabilities-generator/)

You can generate the following example config file to the config folder with:

    [bundle exec] cloud_test generate [-p PROVIDER]
    
Example cloud_test.config.yml:

    #config/cloud_test.yml 
    provider: "browserstack"
    user: "username" # these may not be the login credentials
    key: "password"
    cloud_test_debug: false
    common_caps:
      "acceptSslCerts": true # allow self signed certificates
    browserstack: #optional block
      "browserstack.local": true
      "browserstack.debug": true # Visual log
    browsers:
      IE:
        "browser": "IE"
        "browser_version": "11.0"
        "os": "Windows"
        "os_version": "7"
      CHROME:
        "browser": "chrome"
        "browser_version": "75.0"
        "os": "Windows"
    cucumber_tag: "@cloudtest"

You can choose a specific browser configuration by setting the CLOUD_TEST 
env variable to your preconfigured browser settings by:
    
    export CLOUD_TEST=<BROWSER_CONFIG>
    # or
    CLOUD_TEST=<BROWSER_CONFIG> cucumber
The _provider_ Hash can include specific configuration only for that provider,
 common_caps and browser_caps are provider independent. 
 
 NOTE: Theses capabilities may still be slightly different for each provider.
If you set the cloud_test_debug key to true cloud_test will display some additional
details.
 
And these are the defaults and possible env variable settings:

    [bundle exec] cloud_test list-default-caps PROVIDER
    # will show something like this:

    ENV['CLOUDTEST_PROJECT'] || # folder name
    ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
    ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message
    ENV['CLOUDTEST_OS'] || '10'
    ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
    ENV['CLOUDTEST_BROWSER'] || 'CHROME'
    
Additionally you can do a dry run and show the "real" capabilities:

    [bundle exec] cloud_test list-caps PROVIDER
          
## Usage
You do need a config file, read the configuration section above first.
You need to run the specific tunnel app for each provider in order to setup local testing.
Links:

- Browserstack tunnel should be installed as a 
[gem](https://github.com/browserstack/browserstack-local-ruby),
 so add gem 'browserstack-local' to your gemfile. ([Tunnel Binary](https://s3.amazonaws.com/browserStack/browserstack-local/BrowserStackLocal-linux-x64))
- [CrossBrowserTesting tunnel](https://github.com/crossbrowsertesting/cbt-tunnel-nodejs/releases)
- [Saucelabs tunnel](https://wiki.saucelabs.com/display/DOCS/Setting+Up+Sauce+Connect+Proxy)
- [Lambdatest tunnel](https://s3.amazonaws.com/lambda-tunnel/LT_Linux.zip)

Download the one for your provider and operating system.
Extract the executable and run it. The command should be similar to:

    ./<path_to>/<tunnel> -u <username> -k <password|apikey>

To enable Cloud_Testing you need to set the ENV['CLOUD_TEST'] variable to any value. 

    export CLOUD_TEST=IE
    # or
    CLOUD_TEST=IE cucumber 
The value can be a browser_caps configuration key (e.g. IE, chrome, my_ie_browser_config), and must be defined in the config file.


Additionally you need to require 'cloud_test' and set the capybara driver in the
 features/support/cloud_test.rb file as follows:
 This will be generated automatically if you run:
 
    [bundle exec] cloud_test generate [-p PROVIDER]
 
NOTE: cloud_test registers a Capybara driver named ':cloud_test'

    require 'cloud_test'
 
    if CloudTest.enabled?
      Before do
        Capybara.current_driver = :cloud_test
      end
      After do |scenario|
          if scenario.failed?
              CloudTest.upload_status_to_provider true, page.driver.browser.session_id, scenario.exception
          end
        end
    end
The After hook updates the status in the dashboard of your provider. 
So far this is implemented for browserstack and crossbrowsertesting.

If you want to test your whether your login credentials work, you can use the
following command:

    [bundle exec] cloud_test test-connection
    
To automate things even further you can define a cucumber tag in the config file 
(default: '@cloudtest'), tag all scenarios you wish to run and run the following command:

    [bundle exec] cloud_test start [-q]
This command will run all tagged scenarios sequantially with all browser configurations
defined in the 'browsers' list in your config file. It run the following command for each browser:

    CLOUD_TEST=<browser_config_name> bundle exec cucumber -t <cucumber_tag>
You can also use the following command to execute your own test-command:

    [bundle exec] cloud_test each [-q] <run> <your> <test-suite> 

You can get a list of all available commands with a description if you run:
    
    [bundle exec] cloud_test
    
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/makandra/cloud_test. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cloudtest project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cloud_test/blob/master/CODE_OF_CONDUCT.md).
