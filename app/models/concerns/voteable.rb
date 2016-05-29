module Voteable
  extend ActiveSupport::Concern

  def votes
    self.up_votes - self.down_votes
  end
end
