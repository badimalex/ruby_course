require 'acceptance_helper'

feature 'Question subscribe' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:subscription) { create(:subscription, question: question, user: user) }

  context 'authorized' do
    scenario 'User subscribe question', js: true do
      user.subscriptions << subscription
      sign_in user
      visit question_path(question)

      click_on 'Cancel subscription'
      expect(page).to_not have_link 'Cancel subscription'
      expect(page).to have_link 'Create subscription'
    end
  end
end
