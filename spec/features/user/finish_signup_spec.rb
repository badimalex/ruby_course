require 'rails_helper'

feature 'Signup finish' do
  given(:user) { create(:user) }
  scenario 'With valid data' do
    sign_in user
    visit finish_signup_path(user)
    fill_in 'Email', with: 'new@user.com'
    click_on 'Continue'
    expect(page).to have_content 'Successfully authenticated.'
  end
end
