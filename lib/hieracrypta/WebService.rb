require 'sinatra'

module Hieracrypta
  class WebService < Sinatra::Base

    configure do
      set :run, false
    end

    def initialize
      super
      # This should read the configuration file; for now we'll hardcode:
  
      curDir=File.dirname(__FILE__)
      repository_location = File.expand_path("../../", curDir)
      
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
        @permissions.add_permission(Hieracrypta::PermissionsDocument.new(request.body))
       'Signature trusted'
      rescue Error::UntrustedSignature
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
        begin
          @permissions.get_permission(identity).permit_branch(branch)
        rescue Error::UnknownIdentity
          response.status=404
          return "No permissions found for identity '#{identity}'"
        end
        begin
          content = @git_client.get_branch(branch, file)
        rescue Error::NoSuchFile
          response.status=404
          return "No file '#{file}' on branch '#{branch}'"
        rescue Error::NoSuchBranch
          response.status=404
          return "No branch '#{branch}'"
        end
        begin
          content_type 'text/plain'
          Hieracrypta::Secret.new(identity, content).data
        rescue Error::UnknownIdentity
          response.status=404
          "No key found for identity '#{identity}'"
        end
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
        begin
          @permissions.get_permission(identity).permit_tag(tag)
        rescue Error::UnknownIdentity
          response.status=404
          "No permissions found for identity '#{identity}'"
        end
        begin
          content = @git_client.get_tag(tag, file)
        rescue Error::NoSuchFile
          response.status=404
          return "No file '#{file}' tagged '#{tag}'"
        rescue Error::NoSuchTag
          response.status=404
          return "No tag '#{tag}'"
        end
        begin
          Hieracrypta::Secret.new(identity, content).data
        rescue Error::UnknownIdentity
          response.status=404
          return "No key found for identity '#{identity}'"
        end
      rescue Exception => e
        response.status=500
        e.to_s
      end
    end

  end
end
