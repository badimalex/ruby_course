require 'rails_helper'

describe Answer do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:attachments) }

  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }

  it { should accept_nested_attributes_for :attachments }

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
end
