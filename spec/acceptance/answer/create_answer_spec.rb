require 'rails_helper'

feature 'Answer a question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User answer a question' do
    User.create!(email: 'user@test.com', password: '12345678')
    sign_in user

    visit question_path
    click_on 'Add answer'
    fill_in 'Your Answer', with: 'My awesome answer body'
    click_on 'Post Your Answer'

    expect(page).to have_content 'My awesome answer body'
  end
end
