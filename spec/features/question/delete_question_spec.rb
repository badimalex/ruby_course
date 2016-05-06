require 'rails_helper'

feature 'Delete question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: create(:user)) }

  scenario 'Author deletes own question' do
    sign_in user

    visit question_path(question)
    click_on 'Remove'
    expect(page).to_not have_content(question.title)
    expect(current_path).to eq questions_path
  end

  scenario 'Author deletes another author question' do
    sign_in user

    visit question_path(another_question)
    click_on 'Remove'
    expect(page).to have_content(another_question.title)
    expect(page).to have_content 'You cannot mess with another author\'s post'
    expect(current_path).to eq question_path(another_question)
  end
end
