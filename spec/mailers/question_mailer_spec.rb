require "rails_helper"

RSpec.describe QuestionMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }
  let(:mail) { described_class.new_answer(answer, user.email).deliver_now }

  it 'notify about new answer' do
    expect{ QuestionMailer.new_answer(answer, user.email).deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'assigns answer' do
    expect(mail.body.encoded).to match("/questions/#{question.id}")
    expect(mail.body.encoded).to match(answer.body)
  end
end
