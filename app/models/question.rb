class Question < ActiveRecord::Base
  include Attachable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, :score, presence: true
  validates :title, length: { minimum: 5 }
  validates :body, length: { minimum: 15 }
  validates_numericality_of :score
end
