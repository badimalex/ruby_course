require 'acceptance_helper'

feature 'Accept answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: create(:user)) }
  given(:answers) { create_list(:answer, 2, question: question) }
  given(:other_answers) { create_list(:answer, 2, question: other_question) }
  given(:accepted_answer) { create(:answer, body: 'Best answer is first', question: question, accepted: true) }

  describe 'Authorized user visit own question' do
    before do
      sign_in user
      answers
      visit question_path(question)
    end

    scenario 'can view accept button' do
      answers.each do |answer|
        within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
          expect(page).to have_link 'Accept answer'
        end
      end
    end

    scenario 'can accept own question answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        click_on 'Accept answer'
        expect(page).to have_content 'Accepted'
      end
    end

    scenario 'can re-define accepted answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[1].id}\"]" do
        click_on 'Accept answer'
        expect(page).to have_content 'Accepted'
      end

      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(page).to_not have_content 'Accepted'
      end
    end
  end

  describe 'Authorized user visit other user question' do
    before do
      sign_in user
      other_answers
      visit question_path(other_question)
    end

    scenario 'can view accept button' do
      other_answers.each do |answer|
        within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
          expect(page).to_not have_link 'Accept answer'
        end
      end
    end
  end


  scenario 'Accepted answer is first in list' do
    answers.push accepted_answer
    visit question_path(question)
    save_and_open_page
    within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
      expect(page).to have_content 'Accepted'
      expect(page).to have_content 'Best answer is first'
    end
  end
end
