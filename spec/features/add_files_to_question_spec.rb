require 'acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }

  before do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'My awesome question body'
    attach_file 'File', "#{Rail.root}/spec/spec_helper.rb"

    click_on 'Create'
    expect(page).to have_content 'spec_helper.rb'
  end
end
