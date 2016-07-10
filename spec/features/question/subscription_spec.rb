require 'acceptance_helper'

feature 'Question subscribe' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User subscribe question', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_link 'Cancel subscription'
    click_on 'Create subscription'
    expect(page).to have_link 'Cancel subscription'
    expect(page).to_not have_link 'Create subscription'
  end
end
