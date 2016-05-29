module Voteable
  extend ActiveSupport::Concern

  included do
    has_one :voting, as: :voteable
  end

  def upvote!(user)
    vote!(user, 1)
  end

  def cancelvote!(user)
    last_vote = last_vote_by(user).vote
    increment!(:score, last_vote * -1)
    vote!(user, 0)
  end

  def downvote!(user)
    vote!(user, -1)
  end

  def upvoted?(user)
    voting = fetch_voting(user)
    return false if voting.nil?
    return true if voting.vote == 1
    false
  end

  def downvoted?(user)
    voting = fetch_voting(user)
    return false if voting.nil?
    return true if voting.vote == -1
    false
  end

  def last_vote_by(user)
    Voting.where(voteable_type: self.class.to_s, voteable_id: id, user: user).first
  end

  def vote!(user, score)
    increment!(:score, score)

    if upvoted?(user) or downvoted?(user)
      voting = fetch_voting(user)
      voting.vote = score
    else
      voting = Voting.new(voteable_type: self.class.to_s, voteable_id: id, user: user, vote: score)
    end
      voting.save!
  end

  private

  def fetch_voting(user)
    Voting.where(voteable_type: self.class.to_s, voteable_id: id, user: user).first
  end
end

