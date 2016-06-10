module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable

    validates :up_votes, :down_votes, numericality: true
    validates :up_votes, :down_votes, presence: true
  end

  def rating
    up_votes - down_votes
  end
end
