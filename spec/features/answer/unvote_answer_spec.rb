require 'acceptance_helper'

feature 'Vote answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2, question: question, user: create(:user)) }
  given(:vote) { create(:vote) }

  describe 'Authorized user tries to cancel vote' do
    before do
      answers
      sign_in user
    end

    scenario 'when not already voted cannot view cancel link' do
      visit question_path(question)

      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(page).to_not have_link 'Cancel vote'
      end
    end

    scenario 'when up voted can cancel vote', js: true do
      answers[0].votes<<vote
      user.votes<<vote
      visit question_path(question)

      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        click_on 'Cancel vote'
        expect(find('.vote-up-votes')).to have_content '0'
      end
    end
  end
end
