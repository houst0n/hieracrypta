require 'gpgme'

module Hieracrypta
  class UnencryptedData
    def initialize (identity, data)
      @crypto = GPGME::Crypto.new
      @data = data
      @identity = identity
      if GPGME::Key.find(:secret, @identity).length!=1
        raise Hieracrypta::UnknownIdentity.new(@identity)
      end
    end

    def encrypt
      @crypto.encrypt @data, :recipients => @identity
    end
  end
end
