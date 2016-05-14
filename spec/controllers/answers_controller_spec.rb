require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, user: @user, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js  }
          .to change(question.answers, :count).by(1) && change(@user.answers, :count).by(1)
      end

      it 'associates answer with question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js  }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: { body: nil }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'Delete #destroy' do
    context 'Author deletes own answer' do
      it 'deletes answer' do
        expect { delete :destroy, question_id: question, id: answer }.to change(@user.answers, :count).by(-1)
      end
    end

    context 'Author deletes another author answer' do
      let(:another_user) { create(:user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }

      it 'doesn\'t deletes an answer' do
        expect { delete :destroy, question_id: question, id: another_answer }.to_not change(Answer, :count)
      end
    end

    it 'redirects to question page' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'Edited answer body'}, format: :js
      answer.reload
      expect(answer.body).to eq 'Edited answer body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end
end
