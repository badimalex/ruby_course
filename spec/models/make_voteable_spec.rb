require 'rails_helper'

RSpec.describe Voter do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe '#up_vote' do
    it 'should increase up votes of voteable by one' do
      expect(question.up_votes).to eq(0)
      user.up_vote(question)
      expect(question.up_votes).to eq(1)
    end

    it 'should create a voting' do
      expect(Voting.count).to eq(0)
      user.up_vote(question)
      expect(Voting.count).to eq(1)
      voting = Voting.first
      expect(voting.voteable).to eq(question)
      expect(voting.user).to eq(user)
      expect(voting.score).to eq(1)
    end

  end
end
