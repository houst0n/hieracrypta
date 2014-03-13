require 'hieracrypta'
require 'test/unit'

class PermissionsTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
    @permissions = Hieracrypta::Permissions.new()
  end

  def load_permission(permissions_document_filename, public_key_filename)
    curDir=File.dirname(__FILE__)
    public_key = File.read(File.expand_path("testdata/#{public_key_filename}", curDir)).split("\n").join('\n')
    unsigned_json_file = File.read(File.expand_path("testdata/#{permissions_document_filename}", curDir))
    unsigned_json_file = unsigned_json_file.sub("XXX", public_key)
    secret_data=Hieracrypta::Keyring.admins().sign(unsigned_json_file, 'hieracrypta.admin@dev.null')
    Hieracrypta::PermissionsDocument.new(secret_data)
  end

  def test_unknown_identity
    assert_raise Hieracrypta::Error::UnknownIdentity do
      @permissions.get_permission("made-up-name")
    end
  end

  def test_known_identity
    ["hieracrypta.client.allow@dev.null", "hieracrypta.client.deny@dev.null"].each { |identity|
      assert_raise Hieracrypta::Error::UnknownIdentity do
        permissions_document = @permissions.get_permission(identity)
      end
    }
    @permissions.add_permission(load_permission("permissions_document_allowing_test", "keys/client/hieracrypta.client.allow.public"))
    @permissions.add_permission(load_permission("permissions_document_not_allowing_test", "keys/client/hieracrypta.client.deny.public"))
    ["hieracrypta.client.allow@dev.null", "hieracrypta.client.deny@dev.null"].each { |identity|
      permissions_document = @permissions.get_permission(identity)
      assert_equal Hieracrypta::PermissionsDocument, permissions_document.class
    }
  end

end
