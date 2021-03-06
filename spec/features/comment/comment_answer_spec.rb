require 'acceptance_helper'

feature 'Add comment to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user comment answer', js: true do
    sign_in user
    answer
    visit question_path(question)

    within '.answers' do
      within '.comments-form' do
        fill_in 'Your comment', with: 'My comment text'
        click_on 'Create'
      end

      within '.comments' do
        expect(page).to have_content 'My comment text'
      end
    end
  end
end
