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

    @client_public_key = File.read(File.expand_path("testdata/client_public_key", curDir))

    @trusted_signed_data=File.read(File.expand_path("testdata/trusted_signed_data", curDir))
    @untrusted_signed_data=File.read(File.expand_path("testdata/untrusted_signed_data", curDir))
  end

  def test_decrypt_trusted_allow
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    secret_data=GPGME::Crypto.new().clearsign(unsigned_json_file, :signer => 'hieracrypta@dev.null').to_s
    checked_data=Hieracrypta::PermissionsDocument.new(secret_data)
    assert_equal "hieracrypt-client", checked_data.id
    assert_equal @client_public_key, checked_data.pubkey
    assert_equal 1, checked_data.allow_branch.length
    assert_equal "testbranch", checked_data.allow_branch[0]
    assert_equal 1, checked_data.allow_tag.length
    assert_equal "testtag", checked_data.allow_tag[0]
    assert checked_data.deny_branch.nil?
    assert checked_data.deny_tag.nil?
    assert checked_data.permit_branch('testbranch')
    assert checked_data.permit_tag('testtag')
    assert !checked_data.permit_branch('someotherbranch')
    assert !checked_data.permit_tag('someothertag')
  end

  def test_decrypt_trusted_deny
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_not_allowing_test", curDir))
    secret_data=GPGME::Crypto.new().clearsign(unsigned_json_file, :signer => 'hieracrypta@dev.null').to_s
    checked_data=Hieracrypta::PermissionsDocument.new(secret_data)
    assert_equal "hieracrypt-client", checked_data.id
    assert_equal @client_public_key, checked_data.pubkey
    assert checked_data.allow_branch.nil?
    assert checked_data.allow_tag.nil?
    assert_equal 1, checked_data.deny_branch.length
    assert_equal "testbranch", checked_data.deny_branch[0]
    assert_equal 1, checked_data.deny_tag.length
    assert_equal "testtag", checked_data.deny_tag[0]
    assert !checked_data.permit_branch('testbranch')
    assert !checked_data.permit_tag('testtag')
    assert checked_data.permit_branch('someotherbranch')
    assert checked_data.permit_tag('someothertag')
  end
  
  def test_untrust
    assert_raise Hieracrypta::NotSigned do
      Hieracrypta::PermissionsDocument.new(@untrusted_signed_data)
    end
  end

end
