class Answer < ActiveRecord::Base
  default_scope order('accepted DESC')

  belongs_to :question
  belongs_to :user

  validates :question_id, :user_id, :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :accepted, inclusion: { in: [true, false] }

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update_attribute(:accepted, true)
    end
  end
end
