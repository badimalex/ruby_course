module Votable
  extend ActiveSupport::Concern

  def upvote!
    increment!(:score, 1)
  end
end
