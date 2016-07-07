class DailyMailer < ActionMailer::Base
  default from: "from@example.com"

  def digest(user)
    @questions = Question.last_day.all

    mail to: user.email
  end
end
