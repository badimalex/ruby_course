module Voter
  extend ActiveSupport::Concern

  def up_vote(voteable)
    voting = fetch_voting(voteable)

    if voting
      voting.score = 1
    else
      voting = Voting.new(voteable: voteable, user_id: self.id, score: 1)
    end

    voteable.up_votes += 1

    Voting.transaction do
      save
      voteable.save
      voting.save
    end

    true
  end

  def down_vote(voteable)
    voting = fetch_voting(voteable)

    if voting
      voting.score = -1
    else
      voting = Voting.new(voteable: voteable, user_id: self.id, score: -1)
    end

    voteable.up_votes -= 1

    Voting.transaction do
      save
      voteable.save
      voting.save
    end

    true
  end

  private

  def fetch_voting(voteable)
    Voting.where(
        :voteable_type => voteable.class.to_s,
        :voteable_id => voteable.id,
        :user_id => self.id).first
  end

end
