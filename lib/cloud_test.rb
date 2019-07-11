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

  def self.show_dashboard_link
    Core.list_dashboard_link
  end
end
