require "test_helper"

class CloudtestTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Cloudtest::VERSION
  end

  def test_it_does_something_useful
    assert false
  end

  def setup_fresh
    #ENV['CLOUDTEST'] = 'false'
    @core = ::Cloudtest::Cloudtest_Core
  end

  def test_setup_lambdatest
    #@lt = ::Cloudtest::Lambdatest
    assert_output(/> Running features on lambdatest.com/){::Cloudtest::Lambdatest.new}
  end

  def test_disable_by_default
    setup_fresh
    assert ! @core.enabled
    assert_output(/To enable CloutTest please set the CLOUDTEST env variable to ´true´./){@core.enabled}
  end

  def test_enabled
    setup_fresh
    ENV['CLOUDTEST'] = 'true'
    assert @core.enabled
    assert_output(/You have enabled CloutTest!/){@core.enabled}
  end

  def test_caps_lambdatest
    assert_output(/You can find a caps generator here: https:\/\/www.lambdatest.com\/capabilities-generator\//){::Cloudtest::Crossbrowsertesting.list_caps}
  end

  def test_get_all_caps_lambdatest
    ::Cloudtest::Lambdatest.get_all_caps
  end


end
