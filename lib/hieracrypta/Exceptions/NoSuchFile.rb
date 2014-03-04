module Hieracrypta
  class NoSuchFile < Exception
    def initialize (args)
      super(args)
    end
  end
end
