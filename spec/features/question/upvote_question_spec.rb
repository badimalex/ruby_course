require 'acceptance_helper'

feature 'Up vote question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  vote = '.question>.vote'

  describe 'Authorized user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view up vote link for question' do
      within vote do
        expect(page).to have_link 'Up vote'
      end
    end

    scenario 'can up vote question', js: true do
      within vote do
        expect(find('.vote-score')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-score')).to have_content '1'
      end
    end
  end
end
