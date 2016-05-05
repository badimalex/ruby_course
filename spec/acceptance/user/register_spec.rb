require 'rails_helper'

feature 'Register user' do
  before { visit new_user_registration_path }

  scenario 'With valid data' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'With invalid data' do
    fill_in 'Email', with: nil
    click_on 'Sign up'

    expect(page).to have_content 'errors'
    # на наличие какого путя проверять? происходит перенаправление на /users
    # expect(current_path).to eq new_user_registration_path
  end
end