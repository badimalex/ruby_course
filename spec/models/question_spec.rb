require 'rails_helper'

describe Question do
  it_behaves_like 'Voteable'

  it { should belong_to(:user) }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:up_votes) }
  it { should validate_presence_of(:down_votes) }

  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(15) }
  it { should validate_numericality_of(:up_votes) }
  it { should validate_numericality_of(:down_votes) }

  it { should accept_nested_attributes_for :attachments }

  describe 'daily scope' do
    let!(:last_day_questions) { Array.new(2) { create(:question, created_at: Time.now.midnight - 1.day) } }
    let!(:current_day_questions) { Array.new(2) { create(:question) } }

    it 'returns questions by last day' do
      expect(Question.last_day.all).to match_array(last_day_questions)
    end

    it 'not contain questions by current day' do
      expect(Question.last_day.all).to_not match_array(current_day_questions)
    end
  end

  describe '#subscribe_author' do
    let(:user) { create :user }
    let(:question) { build(:question, user: user) }

    it 'subscribes question owner on question' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end

    it 'performs after question has been created' do
      expect(question).to receive(:subscribe_author)
      question.save
    end
  end
end
