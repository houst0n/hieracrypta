ENV['RACK_ENV'] = 'test'

require 'hieracrypta'
require 'test/unit'
require 'rack/test'
require 'gpgme'

class HieracryptoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Hieracrypta::WebService
  end

  def test_put_identity_without_signature
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    put '/identities/', unsigned_json_file, "CONTENT_TYPE" => "application/json"
    assert ! last_response.ok?
  end
  
  def test_put_identity_with_signature
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    signed_json_file=GPGME::Crypto.new().clearsign(unsigned_json_file, :signer => 'hieracrypta@dev.null').to_s
    put '/identities/', signed_json_file, "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
  end
  
  def test_get_file_by_tag_with_unknown_identity
    get '/file/myidentity/tags/mytag/path/to/my/file.txt'
    assert ! last_response.ok?
  end     

  def test_get_file_by_branch_with_unknown_identity
    get '/file/myidentity/branches/mybranch/path/to/my/file.txt'
    assert ! last_response.ok?
  end

  def test_get_non_existing_file_from_existing_branch_with_known_identity
    get '/file/hieracrypta@dev.null/branches/testbranch/test/unit/testdata/fakefile'
    assert last_response.not_found?
    assert_equal "No file 'test/unit/testdata/fakefile' on branch 'testbranch'", last_response.body
  end
  
  def test_get_non_existing_file_from_existing_tag_with_known_identity
    get '/file/hieracrypta@dev.null/tags/testtag/test/unit/testdata/fakefile'
    assert last_response.not_found?
    assert_equal "No file 'test/unit/testdata/fakefile' tagged 'testtag'", last_response.body
  end

  def test_get_existing_file_from_existing_branch_with_known_identity
    get '/file/hieracrypta@dev.null/branches/testbranch/test/unit/testdata/testfile2'
    assert last_response.ok?
    assert_equal "This is a test file on the branch testbranch\n", GPGME::Crypto.new().decrypt(last_response.body).to_s
  end
  
  def test_get_existing_file_from_existing_tag_with_known_identity
    get '/file/hieracrypta@dev.null/tags/testtag/test/unit/testdata/testfile'
    assert last_response.ok?
    assert_equal "This is a test file on the tag testtag\n", GPGME::Crypto.new().decrypt(last_response.body).to_s
  end
end
