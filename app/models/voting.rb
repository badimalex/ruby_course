class Voting < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :score, presence: true
  validates_numericality_of :score
end
