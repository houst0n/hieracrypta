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

  def test_decrypt_trusted
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    secret_data=GPGME::Crypto.new().clearsign(unsigned_json_file, :signer => 'hieracrypta@dev.null').to_s
    checked_data=Hieracrypta::PermissionsDocument.new(secret_data)
    assert_equal "hieracrypt-client", checked_data.id
    assert_equal "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: GnuPG/MacGPG2 v2.0.22 (Darwin)\nComment: GPGTools - https://gpgtools.org\n\nmI0EUwzKeQEEALKVxtskfXPQ3HuFkwgE56sIXw8WuVaV4WDK/OCU2n+obMpzT/qv\nPFpncXuSW51obWssXqbuicLfDfSTJp8vgcftJzgGemIHpzy7YLsUs08K2c6o6EPS\n+hBpNhOh8k1Z5nc6mYSiNTNTejhvcgHBTy5JrloJtMoB+1JbWackqAYXABEBAAG0\nNEhpZXJhQ3J5cHRhIENsaWVudCBLZXkgPGhpZXJhY3J5cHRhX2NsaWVudEBkZXYu\nbnVsbD6ItwQTAQoAIQUCUwzKeQIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAK\nCRBNqqx34+sG8IS4A/9O9L7DlfvgAzEFZGCWIProPvUL4gS+iK9fsmpzCvdMEncH\nxJG31Oca1Ut9nV1QWQm5YCNwRDDp3gV4ukpnhPOqP3BcXdwhhzeqfLdDQJQlMXcz\n9Iz0+4yUGZYe0frqsc/EnL9dvKWO+5zbxBec9+fHKDpAd5M0Cz9+o1T5OqR/pbiN\nBFMMynkBBADbuNJ8ni4ZS6Gs4IpRbdQSmAUeajRwjUQMJmPteMImkujHz0eRvmad\nbVJJK1RySx3oXcRXVN7fQXoRwqOHCd4zu00hkz4pMc7/3q724Nqp4c+YTmPvAq/u\nJSYtQhq1dXoKx/e6bLNZ4vH626s7dg0SfgOoLvtFFGveLNqG+pRIpwARAQABiJ8E\nGAEKAAkFAlMMynkCGwwACgkQTaqsd+PrBvCxEgQArlRiLXmErCkG4Cwy9kCJuTRA\nyw0CFTDb0JnKnZMQ7ORYw6OitTmhIc4+RWya3FoqS8EK4Xwo9b0ex5qb7I+2SUpH\nQvnUnJ1D8v10dEnX4S7OMurre8JATF4phrUzqKz7xY1RxCWJKVAzgAm0EcG1rCTb\nr4Vx+X4t6uXJD7Y9q2s=\n=5dXn\n-----END PGP PUBLIC KEY BLOCK-----", checked_data.pubkey
    puts checked_data.allow_branch.class
    assert_equal 1, checked_data.allow_branch.length
    assert_equal "testbranch", checked_data.allow_branch[0]
    assert_equal 1, checked_data.allow_tag.length
    assert_equal "testtag", checked_data.allow_tag[0]
    assert checked_data.deny_branch.nil?
    assert checked_data.deny_tag.nil?
  end

  def test_untrust
    assert_raise Hieracrypta::NotSigned do
      Hieracrypta::PermissionsDocument.new(@untrusted_signed_data)
    end
  end

end
