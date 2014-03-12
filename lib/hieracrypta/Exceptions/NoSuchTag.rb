module Hieracrypta::Error
  class NoSuchTag < Exception
    def initialize (args)
      super(args)
    end
  end
end
