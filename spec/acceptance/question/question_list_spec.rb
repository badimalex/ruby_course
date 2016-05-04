require 'rails_helper'

feature 'List question' do
  given!(:questions) { create_list(:question, 5) }

  scenario 'User can view list of questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_link(question.title)
    end
  end
end
