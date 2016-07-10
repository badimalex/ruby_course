require 'rails_helper'

RSpec.describe QuestionNotifierJob, type: :job do
  let(:question) { create :question }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }
  let(:answer) { create :answer, question: question }

  it 'notify user about new answer' do
    answer.question.subscriptions.each do |subscription|
      expect(QuestionMailer).to receive(:new_answer).with(answer, subscription.user.email).and_call_original
    end
    QuestionNotifierJob.perform_now(answer)
  end
end
