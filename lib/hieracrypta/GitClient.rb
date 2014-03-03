require 'rugged'

module Hieracrypta
  class GitClient

    def initialize(repository_location)
      @rugged=Rugged::Repository.new(repository_location)
    end

    def get_tag(tag, file)
      "get_tag #{tag} #{file}"
    end

    def get_branch(branch, file)
      rugged_branch = Rugged::Branch.lookup(@rugged, branch)
      puts rugged_branch
      "get_branch #{branch} #{file}"
    end
  end
end
