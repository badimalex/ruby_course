require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  let!(:users) { create_list(:user, 2) }
  let(:mail) { described_class.digest(users.first).deliver_now }
  let!(:questions) { create_list(:question, 2, created_at: Time.now.midnight - 1.day) }

  it 'send daily digest to all users' do
    users.each do |user|
      expect{ DailyMailer.digest(user).deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  it 'assigns questions attributes' do
    questions.each do |question|
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(question.body)
    end
  end
end
