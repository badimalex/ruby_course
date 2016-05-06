require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'public class methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let(:another_user) { create(:user) }
    let(:another_question) { create(:question, user: another_user) }

     context 'executes methods correctly' do
        it 'returns true, if is author of post' do
          expect(user.author_of(question)).to be true
        end

        it 'returns false, if is NOT author of post' do
          expect(user.author_of(another_question)).to be false
        end
     end
  end
end
