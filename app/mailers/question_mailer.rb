class QuestionMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_answer(answer, email)
    @answer = answer
    @question = answer.question
    mail to: email
  end
end
