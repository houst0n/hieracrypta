require 'gpgme'
require 'json'

module Hieracrypta
  class PermissionsDocument

    attr_reader :id
    attr_reader :pubkey
    attr_reader :allow_branch
    attr_reader :allow_tag
    attr_reader :deny_branch
    attr_reader :deny_tag
  
    def initialize (data)
      @hash=check_and_decrypt(data)
      parse_hash()
    end
    
    def raw
      @hash
    end

    def check_and_decrypt(data)
      crypto = GPGME::Crypto.new()
      document = check_signature(crypto, data)
      begin
        JSON.parse(document)
      rescue GPGME::Error::NoData
        raise Hieracrypta::BadFormat.new()
      end
    end

    def parse_hash
      @id=@hash['id']
      if @id.nil? 
        raise Hieracrypta::BadFormat.new()
      end
      @pubkey=@hash['pubkey']
      if @pubkey.nil? 
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
    
    def check_signature(crypto, data)
      begin
        verified = false
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
