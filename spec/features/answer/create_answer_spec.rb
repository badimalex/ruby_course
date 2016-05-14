require 'acceptance_helper'

feature 'Answer a question' do
  given(:question) { create(:question) }

  scenario 'User answer a question', js: true do
    sign_in

    visit question_path(question)

    fill_in 'Your Answer', with: 'My awesome answer body'
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My awesome answer body'
    end
  end

  scenario 'Non-authenticated user tries to answer a question' do
    visit question_path(question)

    fill_in 'Your Answer', with: 'My awesome answer body'
    click_on 'Post Your Answer'

    expect(page).to_not have_content 'My awesome answer body'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User create invalid answer', js: true do
    sign_in

    visit question_path(question)

    click_on 'Post Your Answer'
    expect(page).to have_content 'Body is too short (minimum is 10 characters)'
  end
end
