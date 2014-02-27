require 'sinatra'

module Hieracrypta
  class WebService < Sinatra::Base

    def initialize
      # This should read the configuration file; for now we'll hardcode:
      repository_location = '/Users/justinrowles/Documents/workspace/hieracrypta'
      puts repository_location
      puts 'create git client'
      @git_client = Hieracrypta::GitClient.new(repository_location)
      puts 'created git client'
      run!
    end

    ####PUT /identities/ + body comprising a signed json object
    #If the request is well formed and signed
    #* HTTP 200
    #If the request body is not well formed
    #* HTTP 400 + body describing error reason
    #If the request body is not signed by a known administrator
    #* HTTP 403 + body describing error reason
    put '/identities/' do
      gpg_signature_client = Hieracrypta::EncryptedData.new(request.body)
      request.body
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
      gpg_encrypter_client = Hieracrypta::UnencryptedData.new(identity, content)
      if (!gpg_encrypter_client.known?) then
        response.status=404
        return "No key found for identity '#{identity}'"
      end
      gpg_encrypter_client.encrypt
    end
  end
end
