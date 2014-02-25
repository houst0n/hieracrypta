require 'sinatra'

module Hieracrypta
  class WebService < Sinatra::Base

    configure do
      set :run, false
    end

    def initialize
      super
    end

    get '/' do
        "Hello World #{params[:name]}".strip
    end

  end
end
