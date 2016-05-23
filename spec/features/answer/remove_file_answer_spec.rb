require 'acceptance_helper'

feature 'Remove answer files' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment) }

  given!(:other_question) { create(:question, user: create(:user)) }
  given!(:another_answer) { create(:answer, user: create(:user), question: other_question) }
  given!(:other_attachment) { create(:attachment) }

  scenario 'Non-authorized user cant delete file', js: true do
    answer.attachments.push attachment
    visit question_path(question)
    expect(page).to_not have_link('Remove attachment')
  end

  describe 'Authorized user visit own question' do
    before do
      sign_in user
    end
    scenario 'User remove file from your question', js: true do
      answer.attachments.push attachment
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content('spec_helper')
        click_on 'Remove attachment'
        expect(page).to_not have_content('spec_helper')
      end
    end

    scenario 'User try to remove other user file', js: true do
      another_answer.attachments.push other_attachment
      visit question_path(other_question)

      within '.answers' do
        expect(page).to have_content('spec_helper')
        expect(page).to_not have_link('Remove attachment')
      end
    end
  end
end
