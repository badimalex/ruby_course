require 'acceptance_helper'

feature 'Remove answer files' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:attachment) { create(:attachment) }

  given(:other_question) { create(:question, user: create(:user)) }
  given(:another_answer) { create(:answer, user: create(:user), question: question) }
  given(:other_attachment) { create(:attachment) }

  xscenario 'Non-authorized user cant delete file', js: true do
    question.attachments.push attachment
    visit question_path(question)
    save_and_open_page
    expect(page).to_not have_link('Add file')
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

    xscenario 'User try to remove other user file', js: true do
      other_question.attachments.push other_attachment
      visit question_path(other_question)

      within '.attachments' do
        expect(page).to have_content('spec_helper')
        expect(page).to_not have_link('Remove attachment')
      end
    end
  end
end
