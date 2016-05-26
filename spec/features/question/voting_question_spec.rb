require 'acceptance_helper'

feature 'Voting answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authorized user' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view voting button' do
      within '.question' do
        expect(page).to have_link 'Up vote'
      end
    end

    scenario 'can vote question', js: true do
      within '.question' do

        within '.vote_count' do
          expect(page).to have_content '0'
        end

      end
    end
  end
end