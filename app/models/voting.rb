class Voting < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :vote, presence: true
  validates_numericality_of :vote
end
