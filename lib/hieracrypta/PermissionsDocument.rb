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
      trusted=false
      begin
        crypto.verify(data) { |signature| trusted = check_signature(signature, trusted) }
      rescue EOFError => e
        if ! force_trust 
          raise Hieracrypta::NotSigned.new()
        end
      end
      if ! trusted and ! force_trust 
        raise Hieracrypta::UntrustedSignature.new()
      end
      begin
        JSON.parse(crypto.decrypt(data).to_s)
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
    
    def check_signature(signature, trusted)
      puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      puts trusted
      puts trusted.class 
      puts signature
      puts signature.class 
      puts signature.key().owner_trust; 
      trusted or signature.pka_trust
      puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
      puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
    end
  end
end
