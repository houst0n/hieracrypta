require 'sinatra'

module Hieracrypta
  class WebService < Sinatra::Base

    def initialize
      super
    end

    get '/' do
        "Hello World #{params[:name]}".strip
    end

  end
end
