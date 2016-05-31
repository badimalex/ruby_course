class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :score, presence: true
  validates :score, numericality: true
end
