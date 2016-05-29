require 'rails_helper'

describe Answer do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:attachments) }
  it { should have_one(:voting) }

  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_presence_of(:score) }

  it { should accept_nested_attributes_for :attachments }
  it { should validate_numericality_of(:score) }

  let(:user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let(:answer) { create(:answer, question: question, user: user) }
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

  describe '#upvote!' do
    it 'increment score by 1' do
      expect { answer.upvote!(current_user) }.to change { answer.score }.from(0).to(1)
    end

    it 'update votings vote' do
      answer.upvote!(current_user)
      voting = Voting.where(voteable_type: 'Answer', voteable_id: answer.id, user: current_user ).first
      expect(voting.vote).to eq 1
    end
  end
end
