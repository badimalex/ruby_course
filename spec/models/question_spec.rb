require 'rails_helper'

describe Question do
  it_behaves_like 'Model voteable'

  it { should belong_to(:user) }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many(:answers).dependent(:destroy) }
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
end
