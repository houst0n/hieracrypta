require 'gpgme'
require 'json'

module Hieracrypta
  class Permissions

    def initialize
      @permissions_map={}
    end

    def get_permission(identity)
      if @permissions_map[identity].nil?
        raise Hieracrypta::UnknownIdentity.new(identity)
      end
      @permissions_map[identity]
    end

    def add_permission(keyring, permissions_document)
      fingerprint = keyring.import_key(permissions_document.pubkey).imports[0].fingerprint()
      key = keyring.get(fingerprint)
      @permissions_map[key.email()]=permissions_document
    end
  end
end
