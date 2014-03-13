require 'hieracrypta'
require 'test/unit'

class KeyringTest < Test::Unit::TestCase

  def initialize (args)
    super(args)

    @admins_keyring  = Hieracrypta::Keyring.admins
    @clients_keyring = Hieracrypta::Keyring.clients
  end

  def test_admin_import
    curDir=File.dirname(__FILE__)
    @admins_keyring.import_key(File.read(File.expand_path("testdata/keys/admin/hieracrypta.admin.public", curDir)))
  end

  def test_admin_directory_import
    assert_equal 1, @admins_keyring.count_keys()
  end

  def test_client_directory_import
    assert_equal 2, @clients_keyring.count_keys()
  end

  def test_release
    @admins_keyring.release
    @clients_keyring.release
  end

end
