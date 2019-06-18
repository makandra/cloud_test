# Cloudtest

Cloudtest enables local Cloud-Testing for a number of providers:
- Browserstack
- CrossBrowserTesting
- saucelabs
- lambdatest

The intention of this gem is to quickly enable Cloud-Testing with minimal setup required.
It assumes your are using capybara and selenium.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudtest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudtest
##Configuration
You can choose between 

a) a cloudtest.config.yml file in the config directory


b) ENV variables

In either case they need to include a 'key' and a 'user' value (login for the chosen provider).
 Additional key/value pairs are possible, for example to configure the browser.

- [Browserstack Configurator](https://www.browserstack.com/automate/capabilities)
- [CrossBrowserTesting Capabilities](https://help.crossbrowsertesting.com/selenium-testing/getting-started/crossbrowsertesting-automation-capabilities/)
- [Saucelabs Configurator](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/)
- [lambdatest Capability Generator](https://www.lambdatest.com/capabilities-generator/)

You can generate the following example config file to the config folder with:

    [bundle exec] cloudtest generate config
    
Example cloudtest.config.yml:

    user: "username"
    key: "password"
    common_caps:
      "browserstack.local": true
      "browserstack.debug": true # Visual log
      "acceptSslCerts": true # allow self signed certificates
      "name": "Bstack-[Capybara] Local Test"
      'resolution' : '1280x1024'
    
    browser_caps:
      -
        "browser": "IE"
        "browser_version": "11.0"
        "os": "Windows"
        "os_version": "7"

And these are the defaults and possible env variable settings:

You can list these with:

    [bundle exec] cloudtest list-default-caps PROVIDER
    # will show something like this:

    ENV['CLOUDTEST_PROJECT'] || # folder name
    ENV['CLOUDTEST_BUILD'] ||  `git rev-parse HEAD` # HEAD commit hash
    ENV['CLOUDTEST_NAME'] || `git log -1 --pretty=%B` # HEAD commit message
    ENV['CLOUDTEST_OS'] || '10'
    ENV['CLOUDTEST_PLATFORM'] || 'WINDOWS'
    ENV['CLOUDTEST_BROWSER'] || 'CHROME'
    
Additionally you can do a dry run and show the "real" capabilities:

    [bundle exec] cloudtest list-caps PROVIDER
          
## Usage

You need to run the specific tunnel app for each provider in order to setup the local tunnel.
Links:

- Browserstack tunnel
should be installed as a [gem](https://github.com/browserstack/browserstack-local-ruby),
 so add gem 'browserstack-local' to your gemfile. ([Tunnel Binary](https://s3.amazonaws.com/browserStack/browserstack-local/BrowserStackLocal-linux-x64))
- [CrossBrowserTesting tunnel](https://github.com/crossbrowsertesting/cbt-tunnel-nodejs/releases)
- [Saucelabs tunnel](https://wiki.saucelabs.com/display/DOCS/Setting+Up+Sauce+Connect+Proxy)
- [Lambdatest tunnel](https://s3.amazonaws.com/lambda-tunnel/LT_Linux.zip)


To enable Cloud-Testing you need to set the ENV['CLOUDTEST'] variable to 1 or true. 

    export CLOUDTEST=1
Additionally you need to require the corresponding provider and set the capybara driver as follows:

    require 'cloudtest/browserstack'
 
    if Browserstack.enabled
      Before do
        Capybara.current_driver = :cloudtest
      end
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cloudtest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cloudtest project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cloudtest/blob/master/CODE_OF_CONDUCT.md).
