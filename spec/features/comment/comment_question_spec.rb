require 'acceptance_helper'

feature 'Add comment to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user comment question' do
    sign_in user
    visit question_path(question)

    within '.question>.comments-form' do
      fill_in 'Your comment', with: 'My comment text'
      click_on 'Create'
    end

    within '.question>.comments' do
      expect(page).to have_content 'My comment text'
    end
  end
end
