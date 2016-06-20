class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Sign Up Configmation'
  end
end
