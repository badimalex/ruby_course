require 'acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before do
    sign_in user
    visit question_path(question)
  end

  scenario 'User attach many files when answer', js: true do
    fill_in 'Your Answer', with: 'My body answer'
    within '.answer_form' do
      within '.files li:nth-child(1)' do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'Add file'

      within '.files li:nth-child(2)' do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Post Your Answer'
    end
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: /spec_helper.rb/
      expect(page).to have_link 'rails_helper.rb', href: /rails_helper.rb/
    end
  end
end
