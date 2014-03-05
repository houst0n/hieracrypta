require 'gpgme'

module Hieracrypta
  class Secret
    def initialize (identity, data)
      if GPGME::Key.find(:secret, identity).length!=1
        raise Hieracrypta::UnknownIdentity.new(@identity)
      end
      crypto = GPGME::Crypto.new
      @data = crypto.encrypt data, :recipients => @identity
    end
  end
end
