require 'rails_helper'

feature 'Create question' do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    User.create!(email: 'user@test.com', password: '12345678')

    sign_in user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'My awesome question body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'
    expect(page). to have_content 'You need to sign in or sign up before continuing.'
  end
end
