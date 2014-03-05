require 'gpgme'
require 'json'

module Hieracrypta
  class PermissionsDocument
    def initialize (data, force_trust = false)
      crypto = GPGME::Crypto.new()
      begin
        crypto.verify(data) { |signature| puts signature; signature.from }
      rescue Exception => e
        if ! force_trust 
          raise Hieracrypta::UntrustedSignature.new()
        end
      end
      begin
        @hash=JSON.parse(crypto.decrypt(data).to_s)
      rescue GPGME::Error::NoData
        raise Hieracrypta::BadFormat.new()
      end
      @id=@hash['id']
      if @id.nil? and ! force_trust
        raise Hieracrypta::BadFormat.new()
      end
      @pubkey=@hash['pubkey']
      if @pubkey.nil? and ! force_trust
        raise Hieracrypta::BadFormat.new()
      end
      allow=@hash['allow']
      if !allow.nil?
        @allow_branch=allow['branch']
        @allow_tag=allow['tag']
      end
      deny=@hash['deny']
      if !deny.nil?
        @deny_branch=deny['branch']
        @deny_tag=deny['tag']
      end
    end
    
    def raw
      @hash
    end

  end
end
