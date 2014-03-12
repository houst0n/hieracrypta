module Hieracrypta::Error
  class NoSuchFile < Exception
    def initialize (args)
      super(args)
    end
  end
end
