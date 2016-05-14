require 'acceptance_helper'

feature 'Delete answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:another_answer) { create(:answer, user: create(:user), question: question) }

  scenario 'Author deletes own answer', js: true  do
    sign_in user
    answer

    visit question_path(question)
    click_on 'Remove answer'

    expect(page).to_not have_content(answer.body)
    expect(current_path).to eq question_path(question)
  end

  scenario 'Author deletes another author answer' do
    sign_in user
    another_answer

    visit question_path(question)
    expect(page).to_not have_link 'Remove answer'
  end
end
