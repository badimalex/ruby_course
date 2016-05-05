require 'rails_helper'

feature 'User sign out' do
  given(:user) { create(:user) }

  scenario 'User try to sign out' do
    sign_in user

    #  нужно написать тест и реализовать функционал,
    #  чтобы эту кнопку видел только залогиненый ?
    click_on 'Logout' 
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
