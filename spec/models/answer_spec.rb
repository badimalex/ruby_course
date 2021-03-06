require 'rails_helper'

describe Answer do
  it_behaves_like 'Voteable'

  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:attachments) }
  it { should have_many :votes }
  it { should have_many(:comments) }

  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_presence_of(:up_votes) }
  it { should validate_presence_of(:down_votes) }

  it { should accept_nested_attributes_for :attachments }
  it { should validate_numericality_of(:up_votes) }
  it { should validate_numericality_of(:down_votes) }

  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let(:answer) { create(:answer, question: question) }
  let(:accepted_answer) { create(:answer, question: question, accepted: true) }

  it 'should default accepted to false' do
    expect(answer.accepted).to eq false
  end

  describe '#accept!' do
    it 'accept answer' do
      expect { answer.accept! }.to change { answer.accepted }.from(false).to(true)
    end

    it 'set other answers.accepted to false' do
      expect { answer.accept! }.to change { accepted_answer.reload.accepted }.from(true).to(false)
    end
  end

  describe 'default scope' do
    it 'orders by accepted' do
      answers.push accepted_answer
      Answer.first.should eq(accepted_answer)
    end
  end

  describe '.notify_subscriber' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    subject { build(:answer, question: question) }

    it 'should notify question author' do
      expect(QuestionNotifierJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  end
end
