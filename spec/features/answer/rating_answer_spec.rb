require 'acceptance_helper'

feature 'Viewing answer rating' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: create(:user)) }
  given(:answer) { create(:answer, question: question, user: create(:user)) }
  given(:vote) { create(:vote) }

  describe 'Authorized user' do
    scenario 'can view updated rating after up vote', js: true do
      sign_in user
      answer
      visit question_path(question)

      within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
        expect(find('.vote-up-votes')).to have_content '0'

        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
        expect(find('.rating')).to have_content '1'
      end
    end
  end

  describe 'Non-authorized user' do
    scenario 'can view answer rating' do
      answer
      visit question_path(question)

      within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
        expect(find('.rating')).to have_content '0'
      end
    end
  end
end
