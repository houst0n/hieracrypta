require 'rugged'

module Hieracrypta
  class GitClient

    def initialize#(repository_location)
      super
      #puts repository_location
      #@rugged=Rugged::Repository.new(repository_location)
    end
    
    def get_tag(tag, file)
      #@rugged.
      "get_tag #{tag} #{file}"
    end

    def get_branch(branch, file)
      "get_branch #{branch} #{file}"
    end
  end
end
