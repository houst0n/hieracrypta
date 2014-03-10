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
      @git_client = Hieracrypta::GitClient.new(repository_location)
      @permissions = Hieracrypta::Permissions.new()
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
        @permissions.add_permission(
          Hieracrypta::PermissionsDocument.new(request.body)
          )
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
      begin
        file = params[:splat][0]
        identity=params[:identity]
        branch=params[:branch]
        @permissions.get_permission(identity).permit_branch(branch)
        content = @git_client.get_branch(branch, file)
        content_type 'text/plain'
        Hieracrypta::Secret.new(identity, content).data
      rescue UnknownIdentity 
        response.status=404
        "No key found for identity '#{identity}'"
      rescue NoSuchFile
        response.status=404
        "No file '#{file}' on branch '#{branch}'"
      rescue NoSuchBranch
        response.status=404
        "No branch '#{branch}'"
      rescue Exception => e
        response.status=500
        e.to_s
      end
    end

    ####GET /file/{identity}/tags/{tag}/{file}
    #If the identity, tag, and file are known and the tag is allowed
    #* HTTP 200 + body comprising encrypted file
    #If the identity, tag, and file are known but the tag is not allowed
    #* HTTP 403 + body describing error reason
    #If the identity, tag or file are not known
    #* HTTP 404 + body describing error reason
    get '/file/:identity/tags/:tag/*' do
      begin
        file = params[:splat][0]
        identity=params[:identity]
        tag=params[:tag]
        @permissions.get_permission(identity).permit_tag(tag)
        content = @git_client.get_tag(tag, file)
        Hieracrypta::Secret.new(identity, content).data
      rescue UnknownIdentity 
        response.status=404
        "No key found for identity '#{identity}'"
      rescue NoSuchFile
        response.status=404
        "No file '#{file}' tagged '#{tag}'"
      rescue NoSuchTag
        response.status=404
        "No tag '#{tag}'"
      rescue Exception => e
        response.status=500
        e.to_s
      end
    end

  end
end
