require 'gpgme'
require 'json'

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
      JSON.parse(@crypto.decrypt(@data).to_s)
    end

  end
end
