require 'gpgme'
require 'pry'

module Hieracrypta
  class Keyring

    def self.locations
      {
        :admins  => '/tmp/admins',
        :clients => '/tmp/clients'
      }
    end

    def initialize(type)
      GPGME::Engine.home_dir = Keyring.locations[type]
      @ctx = GPGME::Ctx.new(:keylist_mode => GPGME::KEYLIST_MODE_LOCAL)
    end

    def list_keys(prefix = "unknown: ")
      @ctx.each_key do |found_key|
         print "#{prefix} #{found_key.fingerprint}::"
         print "#{found_key.uids}\n"
      end
    end

    def count_keys
      index = 0
      @ctx.each_key do |found_key|
         index += 1
      end
      index
    end

    def import_key(pub_key)
      @ctx.import(GPGME::Data.new(pub_key))
      @ctx.import_result()
      #binding.pry
    end

    def import_key_directory(directory)
      Dir["#{directory}/*.asc.txt"].each do |key_file|
        import_key(File.read(key_file))
      end
    end

    def get(fingerprint)
      @ctx.get_key(fingerprint)
    end

    def release
      @ctx.release
    end

    def verify(data)
      @ctx.verify(GPGME::Data.new(data))
    end

    def decrypt(data)
      @ctx.decrypt(GPGME::Data.new(data))
    end

    def check_signature(data)
      crypto = GPGME::Crypto.new()
      begin
        verified = false
        document = crypto.verify(data) { |signature|
            @ctx.each_keys { |found_key|
              if found_key.fingerprint() == signature.fingerprint()
                  verified = true
              end
            }
        }
      rescue GPGME::Error::NoData
        #Occurs when there is no signature, at the point the signature object is referenced.
        raise Hieracrypta::NotSigned.new()
      end

      unless verified
        raise Hieracrypta::UntrustedSignature.new()
      end
      return document.read
    end

  end
end