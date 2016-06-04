module Exceptions
  class AlreadyVotedError < StandardError
    def initialize
      super 'The voteable was already voted by the voter.'
    end
  end
  class OwnerVotedError < StandardError
    def initialize
      super 'The voteable cannot be voted by the owner.'
    end
  end
end
