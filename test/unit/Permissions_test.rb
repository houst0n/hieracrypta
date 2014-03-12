require 'hieracrypta'
require 'test/unit'

class PermissionsTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
    @permissions = Hieracrypta::Permissions.new()
    @ak  = Hieracrypta::Keyring.new(:admins)
    @ak.import_key_directory("/Users/houst0n/Documents/Repos/bgch/puppet-secrets/keys/users")
  end

  def load_permission(permissions_document_filename, public_key_filename)
    curDir=File.dirname(__FILE__)
    public_key = File.read(File.expand_path("testdata/#{public_key_filename}", curDir)).split("\n").join('\n')
    unsigned_json_file = File.read(File.expand_path("testdata/#{permissions_document_filename}", curDir))
    unsigned_json_file = unsigned_json_file.sub("XXX", public_key)
    secret_data=GPGME::Crypto.new().clearsign(unsigned_json_file, :signer => 'hieracrypta@dev.null').to_s
    Hieracrypta::PermissionsDocument.new(@ak, secret_data)
  end

  def test_unknown_identity
    assert_raise Hieracrypta::UnknownIdentity do
      @permissions.get_permission("made-up-name")
    end
  end

  def test_known_identity
    ["hieracrypta.client.allow@dev.null", "hieracrypta.client.deny@dev.null"].each { |identity|
      assert_raise Hieracrypta::UnknownIdentity do
        permissions_document = @permissions.get_permission(identity)
      end
    }
    @permissions.add_permission(load_permission("permissions_document_allowing_test", "hieracrypta.client.allow.public"))
    @permissions.add_permission(load_permission("permissions_document_not_allowing_test", "hieracrypta.client.deny.public"))
    ["hieracrypta.client.allow@dev.null", "hieracrypta.client.deny@dev.null"].each { |identity|
      permissions_document = @permissions.get_permission(identity)
      assert_equal Hieracrypta::PermissionsDocument, permissions_document.class
    }
  end

end
