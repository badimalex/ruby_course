require 'acceptance_helper'

feature 'Vote answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authorized user try vote other answer' do
    given!(:answers) { create_list(:answer, 2, question: question, user: create(:user)) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can view voting links for answer' do
      answers.each do |answer|
        within :xpath, "//div[@data-answer=\"#{answer.id}\"]" do
          expect(find('.vote')).to have_link 'Up vote'
          expect(find('.vote')).to have_link 'Down vote'
        end
      end
    end

    scenario 'can up vote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-up-votes')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
      end
    end

    scenario 'cant up vote answer twice', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-up-votes')).to have_content '0'
        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
        click_on 'Up vote'
        expect(find('.vote-up-votes')).to have_content '1'
        expect(find('.errors')).to have_content 'The voteable was already voted by the voter.'
      end
    end

    scenario 'can down vote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-down-votes')).to have_content '0'
        click_on 'Down vote'
        expect(find('.vote-down-votes')).to have_content '1'
      end
    end

    scenario 'cant down vote answer twice', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(find('.vote-down-votes')).to have_content '0'

        click_on 'Down vote'
        expect(find('.vote-down-votes')).to have_content '1'

        click_on 'Down vote'
        expect(find('.vote-down-votes')).to have_content '1'
        expect(find('.errors')).to have_content 'The voteable was already voted by the voter.'
      end
    end
  end

  describe 'Authorized user tries vote own answer' do
    given!(:answers) { create_list(:answer, 2, question: question, user: user) }

    before do
      sign_in user
      answers
      visit question_path(question)
    end

    scenario 'cant down or up vote answer', js: true do
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(page).to_not have_link 'Up vote'
        expect(page).to_not have_link 'Down vote'
      end
    end
  end

  describe 'Non-authorized user try vote answer' do
    given!(:answers) { create_list(:answer, 2, question: question) }
    scenario 'cant up vote answer', js: true do
      answers
      visit question_path(question)
      within :xpath, "//div[@data-answer=\"#{answers[0].id}\"]" do
        expect(page).to_not have_link 'Up vote'
        expect(page).to_not have_link 'Down vote'
      end
    end
  end
end
