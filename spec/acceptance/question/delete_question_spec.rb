require 'rails_helper'

feature 'Delete question' do
  given(:question) { create(:question) }

  scenario 'Author deletes own question' do
    sign_in

    visit question_path(question)
    click_on 'Remove'
    expect(page).to_not have_content(question.title)
    expect(page).to have_content 'Successfully deleted'
    expect(current_path).to eq questions_path
  end
end
