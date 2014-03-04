require 'hieracrypta'
require 'test/unit'

class EncryptedDataTest < Test::Unit::TestCase

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

  def test_decrypt
    secret_data = Hieracrypta::EncryptedData.new(@example_encrypted)
    assert_equal @example, secret_data.decrypt.to_s
  end

  def test_trust
    secret_data = Hieracrypta::EncryptedData.new(@trusted_signed_data)
    assert_equal true, secret_data.trust_sig?
  end

  def test_untrust
    secret_data = Hieracrypta::EncryptedData.new(@untrusted_signed_data)
    assert_equal false, secret_data.trust_sig?
  end

end