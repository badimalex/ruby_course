require 'rails_helper'

feature 'User sign out' do
  given(:confirmed_user) { create(:user) }

  scenario 'Authorized user try to sign out' do
    sign_in confirmed_user

    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non authorized doesnt see signout button' do
    visit root_path
    expect(page).to_not have_link 'Logout'
  end
end
