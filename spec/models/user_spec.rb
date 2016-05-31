require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let(:another_user) { create(:user) }
    let(:another_question) { create(:question, user: another_user) }

    it 'returns true, if is author of post' do
      expect(user).to be_author_of(question)
    end

    it 'returns false, if is NOT author of post' do
      expect(user).to_not be_author_of(another_question)
    end
  end

  describe '#up_vote' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }

    it 'should increase up votes for question' do
      expect(question.up_votes).to eq 0
      user.up_vote(question)
      expect(question.up_votes).to eq 1
    end

    it 'should increase up votes for answer' do
      expect(answer.up_votes).to eq 0
      user.up_vote(answer)
      expect(answer.up_votes).to eq 1
    end
  end
end
