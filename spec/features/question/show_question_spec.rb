require 'rails_helper'

feature 'Viewing question' do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User can view a question' do
    question
    answers

    visit questions_path
    click_on question.title

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
