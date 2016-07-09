class QuestionNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    QuestionMailer.digest(answer.question, answer).deliver_later
  end
end
