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

    within '.files li:nth-child(1)' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds many files to question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'My awesome question body'

    within '.files li:nth-child(1)' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Add file'

    within '.files li:nth-child(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: /spec_helper.rb/
    expect(page).to have_link 'rails_helper.rb', href: /rails_helper.rb/
  end
end
