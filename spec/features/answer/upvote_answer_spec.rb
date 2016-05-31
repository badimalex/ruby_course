require 'acceptance_helper'

feature 'Up vote answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Authorized user try up vote answer' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view up vote link for answer' do
      answers.each do |answer|
        within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
          expect(find('.vote')).to have_link 'Up vote'
        end
      end
    end

    scenario 'can up vote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-score')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-score')).to have_content '1'
      end
    end
  end

  describe 'Non-authorized user try up vote answer' do
    scenario 'cant up vote question', js: true do
      visit question_path(question)
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-score')).to have_content '0'
        click_on 'Up vote'

        expect(find('.vote-score')).to have_content '0'
        expect(find('.errors')).to have_content 'Only autorized user can vote'
      end
    end
  end
end
