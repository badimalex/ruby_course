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
      expect(question.upvoted?).to be false
    end

    it 'should return true if already upvoted' do
      voting
      expect(question.upvoted?).to be true
    end
  end

end
