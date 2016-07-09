class QuestionMailer < ActionMailer::Base
  default from: "from@example.com"

  def digest(question, answer)
    @answer = answer
    @question = question
    mail to: @question.user.email
  end
end
