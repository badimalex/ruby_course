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
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:own_question) { create(:question, user: user) }
    let(:answer) { create(:answer) }

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

    it 'should raise error if user try to vote own question' do
      expect { user.up_vote(own_question) }.to raise_error('The voteable cannot be voted by the owner.')
    end

    it 'when up vote, should create user vote' do
      expect(Vote.count).to eq 0
      user.up_vote(question)
      expect(Vote.count).to eq 1

      vote = Vote.first
      expect(vote.voteable). to eq question
      expect(vote.user).to eq user
      expect(vote.score).to eq 1
    end

    it 'when down vote, should create user vote' do
      expect(Vote.count).to eq 0
      user.down_vote(question)
      expect(Vote.count).to eq 1

      vote = Vote.first
      expect(vote.voteable). to eq question
      expect(vote.user).to eq user
      expect(vote.score).to eq -1
    end

    it 'should allow user to up vote question only once' do
      user.up_vote(question)
      expect { user.up_vote(question) }.to raise_error('The voteable was already voted by the voter.')
    end

    it 'should allow user to up vote question only once' do
      user.down_vote(question)
      expect { user.down_vote(question) }.to raise_error('The voteable was already voted by the voter.')
    end
  end

  describe '#down_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:own_question) { create(:question, user: user) }

    it 'should decrease down votes of question by one' do
      expect(question.down_votes).to eq 0
      user.down_vote(question)
      expect(question.down_votes).to eq -1
    end

    it 'should decrease down votes of answer by one' do
      expect(answer.down_votes).to eq 0
      user.down_vote(answer)
      expect(answer.down_votes).to eq -1
    end

    it 'should raise error if user try to vote own question' do
      expect { user.down_vote(own_question) }.to raise_error('The voteable cannot be voted by the owner.')
    end
  end
end

