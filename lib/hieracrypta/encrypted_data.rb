require 'gpgme'

module Hieracrypta
  class EncryptedData
    def initialize (data)
      @crypto = GPGME::Crypto.new
      @data = data
      @trusted = false
    end

    def decrypt
      @crypto.decrypt(@data)
    end

    def trust_sig?
      begin
        crypto.verify(@data) { |signature| signature.from }
        @trusted = true
      rescue
        @trusted = false
      end

      @trusted
    end
  end
end
