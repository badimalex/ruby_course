require 'rails_helper'

feature 'Twitter sign in' do

  describe 'Non-registered user' do
    scenario 'try to sign in' do
      visit new_user_session_path
      set_omniauth
      click_on 'Sign in with Twitter'

      fill_in 'Email', with: 'new@user.com'
      click_on 'Continue'

      expect(page).to have_content 'Please find confirmation link at your email box.'

      open_email('new@user.com')

      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Registered user' do
    given(:user) { create(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter', user_id: user, uid: '123456', info: { email: 'confirmed@email.com'})
    end

    scenario 'try to sign in' do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_link 'Logout'
    end
  end
end
