require 'rails_helper'

feature 'Delete answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer){ create(:answer, user: user, question: question) }

  scenario 'Author deletes own answer' do
    sign_in user

    visit question_path(question)
    click_on 'Remove answer'

    expect(page).to have_content 'Your answer successfully removed'
    expect(page).to_not have_content(answer.body)
    expect(current_path).to eq question_path(question)
  end
end
