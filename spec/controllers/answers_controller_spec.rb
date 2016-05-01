require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
    before { get :new, question_id: question.id }
    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end
  end
end
