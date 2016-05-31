class Answer < ActiveRecord::Base
  default_scope { order('accepted DESC') }

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :question_id, :user_id, :body, :up_votes, :down_votes, presence: true
  validates :body, length: { minimum: 10 }
  validates :up_votes, :down_votes, numericality: true

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update!(accepted: true)
    end
  end
end
