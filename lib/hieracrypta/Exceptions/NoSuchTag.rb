module Hieracrypta
  class NoSuchTag < Exception
    def initialize (args)
      super(args)
    end
  end
end
