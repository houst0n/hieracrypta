require 'gpgme'

module Hieracrypta
  class EncryptedData
    def initialize (data)
      @crypto = GPGME::Crypto.new
      @data = data
      begin
        @crypto.verify(@data) { |signature| signature.from }
      rescue
        raise Hieracrypta::UntrustedSignature.new()
      end
    end

    def decrypt
      @crypto.decrypt(@data)
    end

  end
end
