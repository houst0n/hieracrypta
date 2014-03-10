ENV['RACK_ENV'] = 'test'

require 'hieracrypta'
require 'test/unit'
require 'rack/test'
require 'gpgme'

class WebServiceTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def initialize(args)
    super(args)

    curDir=File.dirname(__FILE__)
    
    #Import admin key if it isn't already there    
    GPGME::Key.import(File.read(File.expand_path("testdata/hieracrypta.admin.private", curDir)))
    
    public_key = File.read(File.expand_path("testdata/hieracrypta.client.allow.public", curDir)).split("\n").join('\n')
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_test", curDir))
    @unsigned_json_file = unsigned_json_file.sub("XXX", public_key)
    @signed_json_file=GPGME::Crypto.new().clearsign(@unsigned_json_file, :signer => 'hieracrypta.admin@dev.null').to_s
  end
  
  def app
    Hieracrypta::WebService
  end

  def test_put_identity_with_signature
    load_identity
    assert last_response.ok?
  end
  
  def test_put_identity_without_signature
    put '/identities/', @unsigned_json_file, "CONTENT_TYPE" => "application/json"
    assert ! last_response.ok?
  end
  
  def test_get_file_by_tag_with_unknown_identity
    get '/file/myidentity/tags/mytag/path/to/my/file.txt'
    assert ! last_response.ok?
  end     

  def test_get_file_by_branch_with_unknown_identity
    get '/file/myidentity/branches/mybranch/path/to/my/file.txt'
    assert last_response.not_found?
    assert "No key found for identity 'myidentity'", last_response.body
  end

  def test_get_non_existing_file_from_existing_branch_with_known_identity
    load_identity
    get '/file/hieracrypta.client.allow@dev.null/branches/testbranch/test/unit/testdata/fakefile'
    assert last_response.not_found?
    assert_equal "No file 'test/unit/testdata/fakefile' on branch 'testbranch'", last_response.body
  end
  
  def test_get_non_existing_file_from_nonexisting_branch_with_known_identity
    load_identity
    get '/file/hieracrypta.client.allow@dev.null/branches/fakebranch/test/unit/testdata/fakefile'
    assert last_response.not_found?
    assert_equal "No branch 'fakebranch'", last_response.body
  end
  
  def test_get_non_existing_file_from_existing_tag_with_known_identity
    load_identity
    get '/file/hieracrypta.client.allow@dev.null/tags/testtag/test/unit/testdata/fakefile'
    assert last_response.not_found?
    assert_equal "No file 'test/unit/testdata/fakefile' tagged 'testtag'", last_response.body
  end

  def test_get_non_existing_file_from_nonexisting_tag_with_known_identity
    load_identity
    get '/file/hieracrypta.client.allow@dev.null/tags/faketag/test/unit/testdata/fakefile'
    assert last_response.not_found?
    assert_equal "No tag 'faketag'", last_response.body
  end

  def test_get_existing_file_from_existing_branch_with_known_identity
    load_identity
    get '/file/hieracrypta.client.allow@dev.null/branches/testbranch/test/unit/testdata/testfile2'
    assert last_response.ok? 
    assert_equal "This is a test file on the branch testbranch\n", GPGME::Crypto.new().decrypt(last_response.body).to_s
  end
  
  def test_get_existing_file_from_existing_tag_with_known_identity
    load_identity
    get '/file/hieracrypta.client.allow@dev.null/tags/testtag/test/unit/testdata/testfile'
    assert last_response.ok?
    assert_equal "This is a test file on the tag testtag\n", GPGME::Crypto.new().decrypt(last_response.body).to_s
  end
  
  def load_identity
    put '/identities/', @signed_json_file, "CONTENT_TYPE" => "application/json"
  end
end
