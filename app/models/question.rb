class Question < ActiveRecord::Base
  include Voteable

  scope :last_day, -> { where({ created_at: (Time.now.midnight - 1.day)..Time.now.midnight }) }

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 5 }
  validates :body, length: { minimum: 15 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
