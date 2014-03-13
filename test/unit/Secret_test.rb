require 'hieracrypta'
require 'test/unit'

class SecretTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
  end

  def test_encryption_with_known_identity
    Hieracrypta::Secret.new("hieracrypta.client.allow@dev.null", 'sample text')
  end
  
  def test_refused_encryption_with_unknown_identity
    assert_raise Hieracrypta::Error::UnknownIdentity do
      Hieracrypta::Secret.new('nobody@example.com', @example)
    end
  end

end
