class DailyMailer < ActionMailer::Base
  default from: "from@example.com"

  def digest(user)
    @greeting = "Hi"

    mail to: user.email
  end
end
