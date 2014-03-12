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
        raise Hieracrypta::Error::NoSuchTag.new(tag)
      end
      get_file(root, file)
    end
    
    def get_branch(branch, file)
      root = Rugged::Branch.lookup(@rugged, branch)
      if root.nil?
        raise Hieracrypta::Error::NoSuchBranch.new(branch)
      end
      root=Rugged::Object.lookup(@rugged, root.target()).tree()
      get_file(root, file)
    end
    
    def get_file(root, file)
      file_parts=file.split('/')
      for file_part in file_parts do
        root_hash=root[file_part]
        if root_hash.nil?
          raise Hieracrypta::Error::NoSuchFile.new(file)
        end
        root=Rugged::Object.lookup(@rugged, root_hash[:oid])
      end
      root.content
    end
  end
end
