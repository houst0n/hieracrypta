require 'gpgme'

module Hieracrypta
  class Secret
    def initialize (identity, data)
      if GPGME::Key.find(:public, identity, :sign).length==0
        raise Hieracrypta::UnknownIdentity.new(@identity)
      end
      @data = GPGME::Crypto.new().encrypt data, :recipients => identity, :always_trust => true
    end
    
    def data
      @data.to_s
    end
  end
end
