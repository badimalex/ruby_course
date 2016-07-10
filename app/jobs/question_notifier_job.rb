class QuestionNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.each do |subscription|
      QuestionMailer.new_answer(answer, subscription.user.email).deliver_later
    end
  end
end

