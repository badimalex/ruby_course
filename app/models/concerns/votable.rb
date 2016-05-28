module Votable
  extend ActiveSupport::Concern

  included do
    has_one :voting, as: :voteable
  end

  def upvote!
    increment!(:score, 1)
  end
end
