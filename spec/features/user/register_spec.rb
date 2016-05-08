require 'rails_helper'

feature 'User register' do
  scenario 'With valid data' do
    sign_up_with 'valid@example.com', 'password'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'With invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: nil
    click_on 'Sign up'

    expect(page).to have_content 'errors'
  end
end
