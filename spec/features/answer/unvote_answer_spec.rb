require 'acceptance_helper'

feature 'Vote answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, up_votes: 1, question: question, user: create(:user)) }
  given(:vote) { create(:vote) }

  describe 'Authorized user tries to cancel vote' do
    before do
      answer
      sign_in user
    end

    scenario 'when not already voted cannot view cancel link' do
      visit question_path(question)

      within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
        expect(page).to_not have_link 'Cancel vote'
      end
    end

    scenario 'when up voted can cancel vote', js: true do
      answer.votes<<vote
      user.votes<<vote
      visit question_path(question)

      within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
        expect(find('.vote-up-votes')).to have_content '1'
        click_on 'Cancel vote'
        expect(find('.vote-up-votes')).to have_content '0'
      end
    end
  end
end
