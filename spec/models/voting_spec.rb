require 'rails_helper'

RSpec.describe Voting, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:score) }
  it { should validate_numericality_of(:score) }
end
