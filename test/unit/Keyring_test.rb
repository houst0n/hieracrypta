require 'hieracrypta'
require 'test/unit'

class KeyringTest < Test::Unit::TestCase

  def initialize (args)
    super(args)

    @admins_keyring  = Hieracrypta::Keyring.new(:admins)
    @clients_keyring = Hieracrypta::Keyring.new(:clients)
  end

  def test_admin_import
    curDir=File.dirname(__FILE__)
    @admins_keyring.import_key(File.read(File.expand_path("testdata/hieracrypta.admin.public", curDir)))
  end

  def test_admin_directory_import
    @admins_keyring.import_key_directory("/Users/houst0n/Documents/Repos/bgch/puppet-secrets/keys/users")
  end

  def test_count_keys
    assert_equal 9, @admins_keyring.count_keys()
  end


  def test_release
    @admins_keyring.release
    @clients_keyring.release
  end

end
