require 'acceptance_helper'

feature 'Question editing' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: create(:user)) }

  scenario 'Non-authenticated user try to edit question'
  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end
    scenario 'sees link to edit question' do
      within '.question' do
        expect(page).to have_link('Edit question')
      end
    end
    scenario 'try to edit question', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'Edited question'
        fill_in 'Body', with: 'My awesome edited body'
        click_on 'Save question'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to have_content 'My awesome edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
  scenario 'Authenticated user try to edit other user question'

  # scenario 'Author deletes own question' do
  #   sign_in user
  #
  #   visit question_path(question)
  #   click_on 'Remove'
  #   expect(page).to have_content 'Your question successfully removed'
  #   expect(page).to_not have_content(question.title)
  #   expect(current_path).to eq questions_path
  # end
  #
  # scenario 'Author deletes another author question' do
  #   sign_in user
  #
  #   visit question_path(another_question)
  #   expect(page).to_not have_content 'Remove'
  # end
end
