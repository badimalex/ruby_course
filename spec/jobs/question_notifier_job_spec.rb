require 'rails_helper'

RSpec.describe QuestionNotifierJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  it 'notify user about new answer' do
    expect(QuestionMailer).to receive(:digest).with(question, answer).and_call_original
    QuestionNotifierJob.perform_now(answer)
  end
end
