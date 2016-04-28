class Answer < ActiveRecord::Base
  belongs_to :question

  validates :question_id, :body, presence: true
  validates :body, length: { minimum: 10 }
end
