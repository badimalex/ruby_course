require 'rails_helper'

describe Answer do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should_not allow_value(nil).for(:accepted) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:other_answer) { create(:answer, question: question, accepted: true) }

  it 'should default accepted to false' do
    expect(answer.accepted).to eq false
  end

  describe '#accept!' do
    it 'accept answer' do
      expect { answer.accept! }.to change { answer.accepted }.from(false).to(true)
    end

    it 'set other answers.accepted to false' do
      expect { answer.accept! }.to change { other_answer.reload.accepted }.from(true).to(false)
    end
  end
end
