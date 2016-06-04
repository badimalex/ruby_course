require 'acceptance_helper'

feature 'Viewing question rating' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: create(:user)) }

  describe 'Authorized user' do
    scenario 'can view updated rating after up vote', js: true do
      sign_in user
      visit question_path(question)

      within '.question>.vote' do
        expect(find('.vote-up-votes')).to have_content '0'

        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
        expect(find('.rating')).to have_content '1'
      end
    end
  end

  describe 'Non-authorized user' do
    scenario 'can view question rating' do
      visit question_path(question)

      within '.question>.vote' do
        expect(find('.rating')).to have_content '0'
      end
    end
  end
end
