class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable
  belongs_to :user

  validates :title, :body, :user_id, :votes, presence: true
  validates :title, length: { minimum: 5 }
  validates :body, length: { minimum: 15 }
  validates_numericality_of :votes

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
