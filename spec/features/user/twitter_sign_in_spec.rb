require 'rails_helper'

feature 'Twitter sign in' do
  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    set_omniauth
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: 'new@user.com'
    click_on 'Continue'

    expect(page).to have_content 'Successfully authenticated.'
    expect(current_path).to eq root_path
  end
end
