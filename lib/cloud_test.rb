require "cloud_test/version"
require "cloud_test/core"


module CloudTest
  class Error < StandardError; end
  def self.enabled?
    ENV.has_key?('CLOUD_TEST')
  end
  if enabled?
    config = Core.load_config
    CloudTest::Core.get_provider_class(config).init config
  end

  at_exit do # is this better in here or in the cloud_test.rb file with the Before tag?
    if $!.nil? || $!.is_a?(SystemExit) && $!.success? # if test was successful
      Core.list_dashboard_link
    else
      code = $!.is_a?(SystemExit) ? $!.status : 1 #if test was not successful, keep exit code
      Core.list_dashboard_link
      exit code
    end
  end
end
