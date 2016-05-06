require 'rails_helper'

feature 'Answer a question' do
  given(:question) { create(:question) }

  scenario 'User answer a question' do
    sign_in

    visit question_path question
    click_on 'Add answer'
    fill_in 'Your Answer', with: 'My awesome answer body'
    click_on 'Post Your Answer'

    expect(page).to have_content 'My awesome answer body'
  end
  
  scenario 'Non-authenticated user tries to answer a question' do
    visit question_path question

    click_on 'Add answer'
    expect(page). to have_content 'You need to sign in or sign up before continuing.'
  end
end
