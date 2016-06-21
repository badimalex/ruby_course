require 'rails_helper'

feature 'Create question' do
  scenario 'Authenticated user creates a question' do
    sign_in

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'My awesome question body'
    click_on 'Create'

    expect(page).to have_content 'Question was successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end
end
