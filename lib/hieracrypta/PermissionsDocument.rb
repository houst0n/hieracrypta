require 'gpgme'
require 'json'

module Hieracrypta
  class PermissionsDocument
    def initialize (data, force_trust = false)
      @hash=check_and_decrypt(data, force_trust)
      parse_hash(force_trust)
    end
    
    def raw
      @hash
    end

    def check_and_decrypt(data, force_trust)
      crypto = GPGME::Crypto.new()
      document = check_signature(crypto, data, force_trust)
      begin
        JSON.parse(document)
      rescue GPGME::Error::NoData
        raise Hieracrypta::BadFormat.new()
      end
    end

    def parse_hash(force_trust)
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
    
    def check_signature(crypto, data, force_trust)
      begin
        verified = force_trust
        document = crypto.verify(data) { |signature|
          if ! verified
            if signature.key().owner_trust > 0
              verified = true
            end
          end 
        }
      rescue EOFError 
        #Occurs when there is no signature, at the point the signature object is referenced.
        raise Hieracrypta::NotSigned.new()
      end
      if verified
        return document.read
      end
      raise Hieracrypta::UntrustedSignature.new()
    end
  end
end
