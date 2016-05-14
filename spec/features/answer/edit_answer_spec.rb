require 'acceptance_helper'

feature 'Answer editing' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'My awesome edited answer body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'My awesome edited answer body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit other user answer'
  end
end
