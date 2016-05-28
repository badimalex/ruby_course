require 'acceptance_helper'

feature 'Vote question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

    describe 'Authorized user' do
      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'can view vote button' do
        within ".question" do
          expect(page).to have_link 'Upvote'
        end
      end

      scenario 'can upvote question', js: true do
        within ".question" do
          expect(page).to have_link 'Upvote'

          expect(find('.vote-count-post')).to have_content '0'

          click_on 'Upvote'

          expect(find('.vote-count-post')).to have_content '1'

        end
      end
    end
end
