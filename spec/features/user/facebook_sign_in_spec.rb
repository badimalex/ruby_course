require 'rails_helper'

feature 'Facebook sign in' do
  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    set_omniauth
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(current_path).to eq root_path
  end
end
