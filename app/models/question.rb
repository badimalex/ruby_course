class Question < ActiveRecord::Base
  include Voteable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable
  has_many :votings, as: :voteable
  belongs_to :user

  validates :title, :body, :user_id, :down_votes, :up_votes, presence: true
  validates :title, length: { minimum: 5 }
  validates :body, length: { minimum: 15 }
  validates_numericality_of :up_votes, :down_votes

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
