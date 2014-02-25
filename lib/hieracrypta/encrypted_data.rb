require 'gpgme'

module Hieracrypta
  class EncryptedData
    def initialize
      @crypto = GPGME::Crypto.new
    end

    def decrypt (data)
      @crypto.decrypt(data)
    end
  end
end
