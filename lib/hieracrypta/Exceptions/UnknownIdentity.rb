module Hieracrypta::Error
  class UnknownIdentity < StandardError
    def initialize (args)
      super(args)
    end
  end
end
