class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :user_id, :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :accepted, :inclusion => {:in => [true, false]}

  def accept!
    self.accepted = true
  end
end
