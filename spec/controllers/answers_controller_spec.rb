require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: @user) }

  describe 'POST #new' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
          .to change(Answer, :count).by(1)
      end

      it 'associates answer with question' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, question_id: question.id, answer: { body: nil } }
          .to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, question_id: question.id, answer: { body: nil }
        expect(response).to render_template :new
      end
    end
  end
end
