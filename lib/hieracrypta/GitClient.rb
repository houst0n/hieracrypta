require 'rugged'

module Hieracrypta
  class GitClient

    def initialize(repository_location)
      @rugged=Rugged::Repository.new(repository_location)
    end

    def get_tag(tag, file) 
      begin
        root = @rugged.rev_parse(tag).tree()
      rescue Rugged::ReferenceError
        puts "No such tag refs/tags/#{tag}"
        return nil
      end
      file_parts=file.split('/')
      for file_part in file_parts do
        root_hash=root[file_part]
        if root_hash.nil?
          return nil
        end
        root=Rugged::Object.lookup(@rugged, root_hash[:oid])
      end
      
      root.content
    end
    
    def get_branch(branch, file)
      rugged_branch = Rugged::Branch.lookup(@rugged, branch)
      puts rugged_branch
      "get_branch #{branch} #{file}"
    end
  end
end
