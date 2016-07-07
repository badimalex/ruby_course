require 'rails_helper'

feature 'Notify user on answer question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Question author receive email' do
    sign_in user
    answer
    open_email(user.email)
    expect(page).to have_content answer.body
  end
end
