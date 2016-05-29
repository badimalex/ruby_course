require 'acceptance_helper'

feature 'Question voting' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see up vote link' do
      within '.question>.voting' do
        expect(page).to have_link('Up vote')
      end
    end

    scenario 'vote up question', js: true do
      within '.question>.voting' do
        expect(find('.voting__score')).to have_content 0

        click_on 'Up vote'

        expect(find('.voting__score')).to have_content 1
      end
    end
  end
end
