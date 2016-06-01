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

    scenario 'try up vote twice', js: true do
      within vote do
        expect(find('.vote-up-votes')).to have_content '0'

        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'

        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
        expect(find('.errors')).to have_content 'The voteable was already voted by the voter.'
      end
    end

    scenario 'can down vote question', js: true do
      within vote do
        expect(find('.vote-down-votes')).to have_content '0'

        click_on 'Down vote'
        expect(find('.vote-down-votes')).to have_content '1'
      end
    end

    scenario 'cant down vote twice', js: true do
      expect(find('.vote-down-votes')).to have_content '0'

      click_on 'Down vote'
      expect(find('.vote-down-votes')).to have_content '1'

      click_on 'Down vote'
      expect(find('.vote-down-votes')).to have_content '1'
      expect(find('.errors')).to have_content 'The voteable was already voted by the voter.'
    end
  end


  describe 'Authorized user tries to cancel vote' do
    given(:question) { create(:question, user: create(:user)) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'when not voted cannot view cancel link' do
      expect(page).to_not have_link 'Cancel vote'
    end

    scenario 'can cancel vote after up vote question', js: true do
      within '.question' do
        expect(find('.vote-up-votes')).to have_content '0'
        click_on 'Up vote'
        visit question_path(question)
        expect(page).to have_link 'Cancel vote'
        expect(find('.vote-up-votes')).to have_content '1'
        click_on 'Cancel vote'
        expect(find('.vote-up-votes')).to have_content '0'
      end
    end
  end

  describe 'Authorized user try to vote own question' do
    given(:question) { create(:question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'cant down or up vote question', js: true do
      within vote do
        expect(page).to_not have_link 'Up vote'
        expect(page).to_not have_link 'Down vote'
      end
    end
  end

  describe 'Non-authorized user try vote question' do
    given(:question) { create(:question, user: user) }

    scenario 'cant down or up vote question', js: true do
      visit question_path(question)
        within vote do
          expect(page).to_not have_link 'Up vote'
          expect(page).to_not have_link 'Down vote'
        end
    end
  end
end
