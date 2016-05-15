require 'acceptance_helper'

feature 'Accept answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Authorized user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view accept button' do
      answers.each do |answer|
        within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
          expect(page).to have_content(answer.body)
          expect(page).to have_link 'Accept answer'
        end
      end
    end

    scenario 'can accept answer', js: true do
      within '.answers' do
        random = rand 1..answers.length
        within :xpath, "//div[@data-answer=\"#{random}\"]" do
          click_on 'Accept answer'
          expect(page).to have_content 'Answer successfully accepted'
        end
      end
    end
  end

  scenario 'Authorized user can re-accept other answer'
  scenario 'Accepted answer is first in list'
end
