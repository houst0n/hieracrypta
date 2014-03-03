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
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_master", curDir))
    put '/identities/', unsigned_json_file, "CONTENT_TYPE" => "application/json"
    assert ! last_response.ok?
  end
  
  def test_put_identity_with_signature
    curDir=File.dirname(__FILE__)
    unsigned_json_file = File.read(File.expand_path("testdata/permissions_document_allowing_master", curDir))
    signed_json_file=GPGME::Crypto.new().clearsign(unsigned_json_file, :signer => 'hieracrypta@dev.null').to_s
    puts signed_json_file
    put '/identities/', signed_json_file, "CONTENT_TYPE" => "application/json"
    puts last_response
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
end
