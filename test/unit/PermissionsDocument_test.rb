require 'hieracrypta'
require 'test/unit'

class PermissionsDocumentTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
  end

  def test_decrypt_trusted_allow
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    secret_data=Hieracrypta::Keyring.admins().sign(unsigned_json_file, 'hieracrypta.admin@dev.null')
    checked_data=Hieracrypta::PermissionsDocument.new(secret_data)
    assert_equal 'XXX', checked_data.pubkey
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
    secret_data=Hieracrypta::Keyring.admins().sign(unsigned_json_file, 'hieracrypta.admin@dev.null')
    checked_data=Hieracrypta::PermissionsDocument.new(secret_data)
    assert_equal 'XXX', checked_data.pubkey
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

  def test_signed
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    assert_raise Hieracrypta::Error::NotSigned do
      Hieracrypta::PermissionsDocument.new(unsigned_json_file)
    end
  end

  def test_untrusted
    #This can't actually be done because trust settings can't be managed in GPGME yet, so all loaded keys in a given keyring must be trusted.
  end

  def test_signed_not_json
    secret_data=Hieracrypta::Keyring.admins().sign('junk', 'hieracrypta.admin@dev.null')
    assert_raise Hieracrypta::Error::BadFormat do
      Hieracrypta::PermissionsDocument.new(secret_data)
    end
  end
end
