require 'hieracrypta'
require 'test/unit'

class PermissionsDocumentTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
    curDir=File.dirname(__FILE__)

    GPGME::Key.import(File.read(File.expand_path("testdata/private_key", curDir)))
    GPGME::Key.import(File.read(File.expand_path("testdata/public_key", curDir)))

    @example = File.read(File.expand_path("testdata/example", curDir))
    @example_encrypted = File.read(File.expand_path("testdata/example_encrypted", curDir))

    @trusted_signed_data=File.read(File.expand_path("testdata/trusted_signed_data", curDir))
    @untrusted_signed_data=File.read(File.expand_path("testdata/untrusted_signed_data", curDir))
  end

  def test_decrypt_trusted_but_badly_formatted
    secret_data = Hieracrypta::PermissionsDocument.new(@example_encrypted, true)
    assert_equal 'This text is encrypted', secret_data.raw()['message']
  end

  def test_untrust
    assert_raise Hieracrypta::NotSigned do
      Hieracrypta::PermissionsDocument.new(@untrusted_signed_data)
    end
  end

end
