require 'acceptance_helper'

feature 'Vote question' do
  given(:user) { create(:user) }

  describe 'Authorized user tries to vote other question' do
    given(:question) { create(:question, user: create(:user)) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view voting links for question' do
      within '.question>.vote' do
        expect(page).to have_link 'Up vote'
        expect(page).to have_link 'Down vote'
      end
    end

    scenario 'can up vote question', js: true do
      within '.question>.vote' do
        expect(find('.vote-up-votes')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
      end
    end

    scenario 'try up vote twice', js: true do
      within '.question>.vote' do
        expect(find('.vote-up-votes')).to have_content '0'

        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'

        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
        expect(find('.errors')).to have_content 'The voteable was already voted by the voter.'
      end
    end

    scenario 'can down vote question', js: true do
      within '.question>.vote' do
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
    given(:question) { create(:question, up_votes: 1, user: create(:user)) }
    given(:other_question) { create(:question, user: create(:user)) }
    given(:vote) { create(:vote) }

    before do
      question.votes << vote
      user.votes << vote
      sign_in user
    end

    scenario 'when not voted cannot view cancel link' do
      visit question_path(other_question)

      expect(page).to_not have_link 'Cancel vote'
    end

    scenario 'when up voted can cancel vote', js: true do
      visit question_path(question)
      within '.question' do
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
      within '.question>.vote' do
        expect(page).to_not have_link 'Up vote'
        expect(page).to_not have_link 'Down vote'
      end
    end
  end

  describe 'Non-authorized user try vote question' do
    given(:question) { create(:question, user: user) }

    scenario 'cant down or up vote question', js: true do
      visit question_path(question)
        within '.question>.vote' do
          expect(page).to_not have_link 'Up vote'
          expect(page).to_not have_link 'Down vote'
        end
    end
  end
end
