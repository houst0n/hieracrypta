require 'gpgme'

module Hieracrypta
  class Secret
    
    def initialize (identity, data)
      @data = Hieracrypta::Keyring.clients().encrypt(data, identity)
    end
    
    def data
      @data.to_s
    end
  end
end
