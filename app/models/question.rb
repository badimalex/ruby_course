class Question < ActiveRecord::Base
  include Voteable
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable
  has_many :votes, as: :voteable
  belongs_to :user

  validates :title, :body, :user_id, :up_votes, :down_votes, presence: true
  validates :title, length: { minimum: 5 }
  validates :body, length: { minimum: 15 }
  validates :up_votes, :down_votes, numericality: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
