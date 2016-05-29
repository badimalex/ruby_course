require 'acceptance_helper'

feature 'Vote question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answer, 2, question: question) }
  given(:other_question) { create(:question, user: create(:user)) }

  describe 'Authorized user vote other question' do
    before do
      sign_in user
      visit question_path(other_question)
    end

    scenario 'can view vote button for question' do
      within ".question" do
        expect(page).to have_link 'Upvote'
        expect(page).to have_link 'Downvote'
      end
    end

    scenario 'can upvote question', js: true do
      within ".question" do
        expect(find('.vote-score')).to have_content '0'

        click_on 'Upvote'
        expect(find('.vote-score')).to have_content '1'

        click_on 'Upvote'
        expect(find('.vote-score')).to have_content '1'
        expect(page).to have_content 'You can not vote twice'
      end
    end

    scenario 'can downvote question', js: true do
      within ".question" do
        expect(find('.vote-score')).to have_content '0'

        click_on 'Downvote'
        expect(find('.vote-score')).to have_content '-1'

        click_on 'Downvote'
        expect(find('.vote-score')).to have_content '-1'
        expect(page).to have_content 'You can not vote twice'
      end
    end
  end

  describe 'Authorized user vote answer' do
    before do
      sign_in user
      answers
      visit question_path(question)
    end

    scenario 'can view vote button for answer' do
      answers.each do |answer|
        within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
          expect(page).to have_link 'Upvote'
        end
      end
    end

    scenario 'can upvote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-score')).to have_content '0'

        click_on 'Upvote'
        expect(find('.vote-score')).to have_content '1'

        click_on 'Upvote'
        expect(find('.vote-score')).to have_content '1'
        expect(page).to have_content 'You can not vote twice'
      end
    end

    scenario 'can downvote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-score')).to have_content '0'

        click_on 'Downvote'
        expect(find('.vote-score')).to have_content '-1'

        click_on 'Downvote'
        expect(find('.vote-score')).to have_content '-1'
        expect(page).to have_content 'You can not vote twice'
      end
    end
  end

  describe 'Authorized user visit own question' do
    before do
      sign_in user
      answers
      visit question_path(question)
    end

    scenario 'cant upvote question', js: true do
      within ".question" do
        expect(find('.vote-score')).to have_content '0'
        click_on 'Upvote'
        expect(find('.vote-score')).to have_content '0'
      end
    end

    scenario 'cant upvote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-score')).to have_content '0'
        click_on 'Upvote'
        expect(find('.vote-score')).to have_content '0'
      end
    end
  end
end
