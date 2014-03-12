require 'gpgme'
require 'json'

module Hieracrypta
  class PermissionsDocument

    attr_reader :pubkey
    attr_reader :allow_branch
    attr_reader :allow_tag
    attr_reader :deny_branch
    attr_reader :deny_tag

    def initialize(admin_keyring, data)
      @ak=admin_keyring
      @hash=check_and_decrypt(data)
      parse_hash()
    end

    def check_and_decrypt(data)
      document = @ak.check_signature(data)
      begin
        JSON.parse(document)
      rescue GPGME::Error::NoData
        raise Hieracrypta::BadFormat.new()
      end
    end

    def parse_hash
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

    def permit_tag(checking_tag)
      if !@allow_tag.nil?
        @allow_tag.each() { |tag| if tag==checking_tag; return true; end; }
        return false
      end
      if !@deny_tag.nil?
        @deny_tag.each() { |tag| if tag==checking_tag; return false; end; }
      end
      return true
    end

    def permit_branch(checking_branch)
      if !@allow_branch.nil?
        @allow_branch.each() { |branch| if branch==checking_branch; return true; end; }
          return false
      end
      if !@deny_branch.nil?
        @deny_branch.each() { |branch| if branch==checking_branch; return false; end }
      end
      return true
    end
  end
end
