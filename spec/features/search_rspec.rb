require 'rails_helper'

feature 'Search' do
  given!(:question) { create(:question, title: 'avokado') }
  given!(:answer) { create(:answer, body: 'limon fruit') }

  before do
    index
    visit root_path
  end

  scenario 'can view search button' do
    expect(page).to have_link 'Advanced search'
  end

  scenario 'questions' do
    click_on 'Advanced search'
    fill_in 'Query', with: question.title
    select 'questions', from: 'section'
    click_on 'Find'
    expect(page).to have_link(question.title)
  end

  scenario 'answers' do
    click_on 'Advanced search'
    fill_in 'Query', with: 'limon'
    select 'answers', from: 'section'
    click_on 'Find'
    expect(page).to have_link(answer.body)
  end
end
