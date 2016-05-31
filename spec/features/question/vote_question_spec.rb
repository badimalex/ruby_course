require 'acceptance_helper'

feature 'Vote question' do
  given(:user) { create(:user) }

  vote = '.question>.vote'

  describe 'Authorized user tries to vote other question' do
    given(:question) { create(:question, user: create(:user)) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view voting links for question' do
      within vote do
        expect(page).to have_link 'Up vote'
        expect(page).to have_link 'Down vote'
      end
    end

    scenario 'can up vote question', js: true do
      within vote do
        expect(find('.vote-up-votes')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
      end
    end

    scenario 'can down vote question', js: true do
      within vote do
        expect(find('.vote-down-votes')).to have_content '0'
        click_on 'Down vote'
        expect(find('.vote-down-votes')).to have_content '-1'
      end
    end
  end

  describe 'Authorized user tries to up vote own question' do
    given(:question) { create(:question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'cant up vote question', js: true do
      within vote do
        expect(find('.vote-up-votes')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '0'
        expect(find('.errors')).to have_content 'The voteable cannot be voted by the owner.'
      end
    end
  end

  describe 'Non-authorized user try up vote question' do
    given(:question) { create(:question, user: user) }

    scenario 'cant up vote question', js: true do
      visit question_path(question)
        within vote do
          expect(find('.vote-up-votes')).to have_content '0'
          click_on 'Up vote'

          expect(find('.vote-up-votes')).to have_content '0'
          expect(find('.errors')).to have_content 'Only autorized user can vote'
        end
    end
  end
end