module Voteable
  extend ActiveSupport::Concern

  def rating
    up_votes-down_votes;
  end
end
