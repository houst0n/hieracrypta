require 'gpgme'
require 'json'

module Hieracrypta
  class Permissions

    def initialize
      @permissions_map={}
      @clients_keyring = Hieracrypta::Keyring.new(:clients)
    end

    def get_permission(identity)
      if @permissions_map[identity].nil?
        raise Hieracrypta::UnknownIdentity.new(identity)
      end
      @permissions_map[identity]
    end

    def add_permission(permissions_document)
      fingerprint = @clients_keyring.import_key(permissions_document.pubkey).imports[0].fingerprint()
      key = @clients_keyring.get(fingerprint)
      @permissions_map[key.email()]=permissions_document
    end
  end
end
