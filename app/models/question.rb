class Question < ActiveRecord::Base
  include Voteable
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 5 }
  validates :body, length: { minimum: 15 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :update_reputation

  private

  def update_reputation
    self.delay.calculate_reputation
  end

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end
