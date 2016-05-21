require 'acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:attachment) { create(:attachment) }


  scenario 'User remove file from your question', js: true do
    sign_in user
    question.attachments.push attachment
    visit question_path(question)

    within '.attachments' do
      expect(page).to have_content('spec_helper')
      click_on 'Remove attachment'
      expect(page).to_not have_content('spec_helper')
    end
  end
end
