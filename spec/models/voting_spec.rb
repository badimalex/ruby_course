require 'rails_helper'

RSpec.describe Voting, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }

  it { should validate_presence_of :vote }
  it { should validate_numericality_of(:vote) }


  describe '#upvoted?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:voting) { create(:voting, user: user, voteable: question, vote: 1) }

    it 'should return false if not already upvoted' do
      expect(question.upvoted?(user)).to be false
    end

    it 'should return true if upvoted' do
      voting
      expect(question.upvoted?(user)).to be true
    end
  end

  describe '#downvoted?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:voting) { create(:voting, user: user, voteable: question, vote: -1) }

    it 'should return false if not already downvoted' do
      expect(question.downvoted?(user)).to be false
    end

    it 'should return true if downvoted' do
      voting
      expect(question.downvoted?(user)).to be true
    end
  end

  describe '#last_vote_by' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:current_user) { create(:user) }

    it 'should return last user vote' do
      question.vote!(current_user, 1)
      expect(question.last_vote_by(current_user).vote).to eq 1
    end
  end

  describe '#cancelvote!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'reset vote column' do
      question.vote!(user, 1)
      question.cancelvote!(user)
      voting = Voting.where(voteable_type: 'Question', voteable_id: question.id, user: user ).first
      expect(voting.vote).to eq 0
    end

    it 'reset question score by last vote' do
      question.vote!(user, 1)
      question.cancelvote!(user)
      expect(question.score).to eq 0
    end
  end

  describe '#vote!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:voting) { create(:voting, user: user, voteable: question, vote: -1) }

    context 'when first time voting' do
      it 'should create new record' do
        question.vote!(user, 1)
        count = Voting.where(voteable_type: 'Question', voteable_id: question.id, user: user ).count
        expect(count).to eq 1
      end
    end

    context 'when voting second time' do
      it 'should update old record' do
        question.vote!(user, 1)
        question.reload
        question.vote!(user, -1)
        count = Voting.where(voteable_type: 'Question', voteable_id: question.id, user: user ).count
        expect(count).to eq 1
      end
    end
  end
end
