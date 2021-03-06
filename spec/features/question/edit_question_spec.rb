require 'acceptance_helper'

feature 'Question editing' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: create(:user)) }

  scenario 'Non-authenticated user try to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit question'
    end
  end

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

    scenario 'try to edit question with ivalid data', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: nil
        fill_in 'Body', with: nil
        click_on 'Save question'
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
        within '.question-errors' do
          expect(page).to have_content 'Title can\'t be blank'
          expect(page).to have_content 'Title is too short (minimum is 5 characters)'
          expect(page).to have_content 'Body can\'t be blank'
          expect(page).to have_content 'Body is too short (minimum is 15 characters)'
        end
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

  scenario 'Authenticated user try to edit other user question' do
    sign_in user
    another_question

    visit question_path(another_question)
    expect(page).to_not have_content 'Edit question'
  end
end
