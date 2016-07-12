require 'rails_helper'

feature 'Search' do
  given!(:question) { create(:question, title: 'avokado') }
  given!(:answer) { create(:answer, body: 'limon fruit') }
  given!(:comment) { create(:comment, body: 'juice') }
  given!(:user) { create(:user, email: 'username@mail.ru') }

  before do
    index
    visit root_path
    click_on 'Advanced search'
  end

  scenario 'questions' do
    fill_in 'Query', with: question.title
    select 'questions', from: 'section'
    click_on 'Find'
    expect(page).to have_link(question.title)
  end

  scenario 'answers' do
    fill_in 'Query', with: 'limon'
    select 'answers', from: 'section'
    click_on 'Find'
    expect(page).to have_link(answer.body)
  end

  scenario 'comments' do
    fill_in 'Query', with: comment.body
    select 'comments', from: 'section'
    click_on 'Find'
    expect(page).to have_link(comment.body)
  end

  scenario 'users' do
    fill_in 'Query', with: 'username'
    select 'users', from: 'section'
    click_on 'Find'
    expect(page).to have_link(user.email)
  end

  describe 'everywhere' do
    given!(:question) { create(:question, title: 'everywhere question') }
    given!(:answer) { create(:answer, body: 'everywhere answer') }
    given!(:comment) { create(:comment, body: 'everywhere comment') }
    given!(:user) { create(:user, email: 'everywhere@user.ru') }

    scenario 'search' do
      fill_in 'Query', with: 'everywhere'
      select 'everywhere', from: 'section'
      click_on 'Find'

      expect(page).to have_link(question.title)
      expect(page).to have_link(answer.body)
      expect(page).to have_link(comment.body)
      expect(page).to have_link(user.email)
    end
  end
end
