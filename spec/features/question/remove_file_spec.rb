require 'acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:attachment) { create(:attachment) }

  given(:other_question) { create(:question, user: create(:user)) }
  given(:other_attachment) { create(:attachment) }

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

  scenario 'User try to remove other user file', js: true do
    sign_in user
    other_question.attachments.push other_attachment
    visit question_path(other_question)
    within '.attachments' do
      expect(page).to have_content('spec_helper')
      expect(page).to_not have_link('Remove attachment')
    end
  end
end
