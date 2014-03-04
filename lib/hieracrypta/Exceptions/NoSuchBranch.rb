module Hieracrypta
  class NoSuchBranch < Exception
    def initialize (args)
      super(args)
    end
  end
end
