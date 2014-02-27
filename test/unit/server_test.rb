ENV['RACK_ENV'] = 'test'

require 'hieracrypta'
require 'test/unit'
require 'rack/test'

class HieracryptoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Hieracrypta::WebService
  end

  def test_put_identity_without_signature
    put '/identities/', {:foo => "bar"}.to_json, "CONTENT_TYPE" => "application/json"
    assert ! last_response.ok?
  end
  
  def test_get_file_by_tag_with_unknown_identity
    get '/file/myidentity/tags/mytag/path/to/my/file.txt'
    assert ! last_response.ok?
  end     

  def test_get_file_by_tag_with_unknown_identity
    get '/file/myidentity/branches/mybranch/path/to/my/file.txt'
    assert ! last_response.ok?
  end
end
