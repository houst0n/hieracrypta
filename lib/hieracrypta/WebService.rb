require 'sinatra'

module Hieracrypta
  class WebService < Sinatra::Base

    configure do
      set :run, false
    end
        
    def initialize
      super
      # This should read the configuration file; for now we'll hardcode:
      repository_location = '/Users/justinrowles/Documents/workspace/hieracrypta'
#      @git_client = Hieracrypta::GitClient.new(repository_location)
      puts 'started'
    end

    get '/' do
      'hello world'
    end
    
    ####PUT /identities/ + body comprising a signed json object
    #If the request is well formed and signed
    #* HTTP 200
    #If the request body is not well formed
    #* HTTP 400 + body describing error reason
    #If the request body is not signed by a known administrator
    #* HTTP 403 + body describing error reason
    put '/identities/' do
      begin
        gpg_signature_client = Hieracrypta::EncryptedData.new(request.body)
       'Signature trusted'
      rescue UntrustedSignature
        response.status=403
        'This signature is not trusted'
      end
    end

    ####GET /file/{identity}/branches/{branch}/{file}
    #If the identity, branch, and file are known and the branch is allowed
    #* HTTP 200 + body comprising encrypted file
    #If the identity, branch, and file are known but the branch is not allowed
    #* HTTP 403 + body describing error reason
    #If the identity, branch or file are not known
    #* HTTP 404 + body describing error reason
    get '/file/:identity/branches/:branch/*' do
      file = params[:splat][0]
      identity=params[:identity]
      branch=params[:branch]
      content = @git_client.get_branch(branch, file)
      send(content, identity)
    end

    ####GET /file/{identity}/tags/{tag}/{file}
    #If the identity, tag, and file are known and the tag is allowed
    #* HTTP 200 + body comprising encrypted file
    #If the identity, tag, and file are known but the tag is not allowed
    #* HTTP 403 + body describing error reason
    #If the identity, tag or file are not known
    #* HTTP 404 + body describing error reason
    get '/file/:identity/tags/:tag/*' do
      file = params[:splat][0]
      identity=params[:identity]
      tag=params[:tag]
      content = @git_client.get_tag(tag, file)
      send(content, identity)
    end

    def send(content, identity)
      begin
        gpg_encrypter_client = Hieracrypta::UnencryptedData.new(identity, content)
      rescue UnknownIdentity 
        response.status=404
        return "No key found for identity '#{identity}'"
      end
      gpg_encrypter_client.encrypt
    end
  end
end
