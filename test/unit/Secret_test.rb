require 'hieracrypta'
require 'test/unit'

class SecretTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
    curDir=File.dirname(__FILE__)

    GPGME::Key.import(File.read(File.expand_path("testdata/private_key", curDir)))
    GPGME::Key.import(File.read(File.expand_path("testdata/public_key", curDir)))
    @example = File.read(File.expand_path("testdata/example", curDir))
  end

  def test_encryption_with_known_identity
    Hieracrypta::Secret.new("hieracrypta@dev.null", @example)
  end
  
  def test_refused_encryption_with_unknown_identity
    assert_raise Hieracrypta::UnknownIdentity do
      Hieracrypta::Secret.new('nobody@example.com', @example)
    end
  end

end
