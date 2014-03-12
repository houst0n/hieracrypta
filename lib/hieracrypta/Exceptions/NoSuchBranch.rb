module Hieracrypta::Error
  class NoSuchBranch < Exception
    def initialize (args)
      super(args)
    end
  end
end
