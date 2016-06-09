require 'acceptance_helper'

feature 'Answer editing' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:another_answer) { create(:answer, user: create(:user), question: question) }

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      answer
      visit question_path(question)
    end

    scenario 'sees link to edit answer' do
      within '.answers' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit answer'
      within '.answers' do
        fill_in 'Answer', with: 'My awesome edited answer body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'My awesome edited answer body'
        expect(page).to_not have_selector 'textarea.answer_body'
      end
    end
  end

  scenario 'Author try to edit other author answer' do
    sign_in user
    another_answer

    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end
end
