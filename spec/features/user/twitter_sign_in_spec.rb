require 'rails_helper'

feature 'Twitter sign in' do

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    set_omniauth
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: 'new@user.com'
    click_on 'Continue'

    expect(page).to have_content 'Please confirm email.'

    open_email('new@user.com')

    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
