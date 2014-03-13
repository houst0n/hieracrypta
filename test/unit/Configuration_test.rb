require 'hieracrypta'
require 'test/unit'

class ConfigurationTest < Test::Unit::TestCase

  def initialize (args)
    super (args)
    @configuration = Hieracrypta::Configuration.new(File.expand_path("testdata/testconfig.json", File.dirname(__FILE__)))
  end
  
  def test_read_admin_keyring_location
    assert_equal "wherever", @configuration.get('admin_keyring_location')
  end
  
  def test_read_two_deep
    assert_equal "value", @configuration.get('two/deep')
  end
  
  def test_read_no_such_config_item
    assert_raise Hieracrypta::NoSuchConfiguration do
      @configuration.get('made/up/item')
    end
  end
  
end
