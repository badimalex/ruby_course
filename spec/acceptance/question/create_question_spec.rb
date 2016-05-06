require 'rails_helper'

feature 'Create question' do
  scenario 'Authenticated user creates a question' do
    sign_in

    visit questions_path
    # а как протестировать добавление ответа, без перехода на отдельную страницу?
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
