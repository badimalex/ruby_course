module Voteable
  extend ActiveSupport::Concern

  included do
    has_one :voting, as: :voteable
  end

  def upvote!
    unless upvoted?
      increment!(:score, 1)
      voting = Voting.new(voteable_type: self.class.to_s, voteable_id: id, user: user, vote: 1)
      voting.save!
    end
  end

  def upvoted?
    voting = fetch_voting
    return false if voting.nil?
    return true if fetch_voting.vote == 1
    false
  end

  private
  def fetch_voting
    Voting.where(voteable_type: self.class.to_s, voteable_id: id, user: user ).first
  end
end
