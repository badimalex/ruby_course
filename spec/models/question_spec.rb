require 'rails_helper'

describe Question do
  it { should belong_to(:user) }
  it { should have_one(:voting) }
  it { should have_many :attachments }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:score) }

  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(15) }
  it { should validate_numericality_of(:score) }

  it { should accept_nested_attributes_for :attachments }

  let(:user) { create(:user) }
  let!(:current_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe '#upvote!' do
    it 'increment score by 1' do
      expect { question.upvote!(current_user) }.to change { question.score }.from(0).to(1)
    end
  end

  describe '#downvote!' do
    it 'increment score by 1' do
      expect { question.downvote!(current_user) }.to change { question.score }.from(0).to(-1)
    end

    it 'update votings vote' do
      question.downvote!(current_user)
      voting = Voting.where(voteable_type: 'Question', voteable_id: question.id, user: current_user ).first
      expect(voting.vote).to eq -1
    end
  end
end
