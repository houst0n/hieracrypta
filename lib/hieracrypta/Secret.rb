require 'gpgme'

module Hieracrypta
  class Secret
    def initialize (identity, data)
      if GPGME::Key.find(:secret, identity).length!=1
        raise Hieracrypta::UnknownIdentity.new(@identity)
      end
      @data = GPGME::Crypto.new().encrypt data, :recipients => identity, :always_trust => true
    end
    
    def data
      @data.to_s
    end
  end
end
