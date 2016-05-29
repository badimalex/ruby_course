class Answer < ActiveRecord::Base
  include Attachable, Voteable

  default_scope order('accepted DESC')

  belongs_to :question
  belongs_to :user

  validates :question_id, :user_id, :body, :score, presence: true
  validates :body, length: { minimum: 10 }
  validates_numericality_of :score

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update!(accepted: true)
    end
  end
end
