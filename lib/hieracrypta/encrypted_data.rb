require 'gpgme'

module Hieracrypta
  class EncryptedData
    def initialize (data)
      @crypto = GPGME::Crypto.new
      @data = data
    end

    def decrypt
      @crypto.decrypt(@data)
    end

    def trust_sig?
      begin
        @crypto.verify(@data) { |signature| signature.from }
        true
      rescue
        false
      end
    end
  end
end
