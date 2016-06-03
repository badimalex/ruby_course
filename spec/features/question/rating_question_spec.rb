require 'rails_helper'

feature 'Viewing question rating' do
  given(:question) { create(:question, up_votes: 5, down_votes: 3) }

  scenario 'User can view question rating' do
    visit question_path(question)

    within '.question>.vote' do
        expect(find('.rating')).to have_content '2'
    end
  end
end
