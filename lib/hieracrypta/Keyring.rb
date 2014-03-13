require 'gpgme'

module Hieracrypta
  class Keyring

    def self.locations
      {
        :admins  => {
          :keyring => Hieracrypta.configuration.get_as_file_location('admin_keyring_location'),
          :keys => Hieracrypta.configuration.get_as_file_location('admin_keys_location')
        },
        :clients => {
          :keyring => Hieracrypta.configuration.get_as_file_location('client_keyring_location'),
          :keys => Hieracrypta.configuration.get_as_file_location('client_keys_location')
        }
      }
    end

    def initialize(type)
      location = Keyring.locations[type][:keyring]
      Dir.foreach(location) {|f| File.delete(File.join(location, f)) if f != '.' && f != '..'}
      GPGME::Engine.home_dir = location 
      @ctx = GPGME::Ctx.new(:keylist_mode => GPGME::KEYLIST_MODE_LOCAL)
      import_key_directory(Keyring.locations[type][:keys])
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
      @ctx.import_result.imports[0].fingerprint()
    end

    def import_key_directory(directory)
      Dir["#{directory}/*.public"].each do |key_file|
        puts "importing #{key_file}"
        import_key(File.read(key_file))
      end
      Dir["#{directory}/*.private"].each do |key_file|
        puts "importing #{key_file}"
        import_key(File.read(key_file))
      end
    end

    def get(fingerprint)
      @ctx.get_key(fingerprint)
    end

    def verify(data)
      @ctx.verify(GPGME::Data.new(data))
    end

    def decrypt(data)
      @ctx.decrypt(GPGME::Data.new(data))
    end

    def check_signature(data)
      verified = false
      begin
        document = @ctx.verify(GPGME::Data.new(data))
      rescue GPGME::Error::NoData
        #Occurs when there is no signature, at the point the signature object is referenced.
        raise Hieracrypta::Error::NotSigned.new()
      end
      begin
        signers = @ctx.verify_result().signatures
        signature = signers[0]
        fingerprint = signature.fingerprint
        key = @ctx.get_key(fingerprint)
      rescue EOFError
        raise Hieracrypta::Error::UntrustedSignature.new()
      end
      return document.to_s
    end
    
    def sign(plain, identity)
      @ctx.clear_signers()
      @ctx.add_signer(@ctx.keys(identity)[0])
      data = GPGME::Data.new()
      @ctx.sign(GPGME::Data.new(plain), data, GPGME::GPGME_SIG_MODE_CLEAR)
      data.to_s
    end
    
    def encrypt(plain, identity)
      keys=[]
      key=@ctx.each_key(identity) { | key | keys << key }
      if keys.length()==0
        raise Hieracrypta::Error::UnknownIdentity.new(identity)
      end
      @ctx.encrypt(keys, GPGME::Data.new(plain), GPGME::Data.new(), GPGME::ENCRYPT_ALWAYS_TRUST)
    end

    @@admins=Keyring.new(:admins)
    def self.admins
      @@admins
    end
  
    @@clients=Keyring.new(:clients)
    def self.clients
      @@clients
    end
  end
end
