ENV['RACK_ENV'] = 'test'

require 'hieracrypta'
require 'test/unit'
require 'rack/test'

class HieracryptoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Hieracrypta::WebService
  end

  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
  end

  def test_it_says_hello_to_a_person
    get '/', :name => 'houst0n'
    assert last_response.body.include?('houst0n')
  end
end
