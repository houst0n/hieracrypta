require 'gpgme'

module Hieracrypta
  class UnencryptedData
    def initialize (identity, data)
      @crypto = GPGME::Crypto.new
      @data = data
      @identity = identity
    end

    def known
      GPGME::Key.find(:secret, @identity).length==1
    end

    def encrypt
      @crypto.encrypt @data, :recipients => @identity
    end
  end
end
