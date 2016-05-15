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
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(@user.answers, :count).by(-1)
      end
    end

    context 'Author deletes another author answer' do
      let(:another_user) { create(:user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }

      it 'doesn\'t deletes an answer' do
        expect { delete :destroy, question_id: question, id: another_answer, format: :js }.to_not change(Answer, :count)
      end
    end

    it 'render update template' do
      delete :destroy, question_id: question, id: answer, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'POST #accept' do
    it 'assigns the requested answer to @answer' do
      post :accept, question_id: question, id: answer
      expect(assigns(:answer)).to eq answer
    end

    context 'Author accept own question answer' do
      it 'mark answer as accepted' do
        post :accept, question_id: question, id: answer
        answer.reload
        expect(assigns(:answer).accepted).to be true
      end
    end

    context 'Author accept answer other author question' do
      let(:another_user) { create(:user) }
      let!(:another_question) { create(:question, user: another_user) }
      let!(:another_answer) { create(:answer, user: another_user, question: another_question) }

      it 'doesn\'t accept answer' do
        post :accept, question_id: another_question, id: another_answer
        another_answer.reload
        expect(assigns(:answer).accepted).to be false
      end
    end

    it 'redirects to question show view' do
      post :accept, question_id: question, id: answer
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    context 'Author update other author answer' do
      let(:another_user) { create(:user) }
      let!(:another_answer) do
        create(:answer, body: 'Original answer body', user: another_user, question: question)
      end

      it 'doesn\'t update an answer' do
        patch :update, id: another_answer, question_id: question, answer: { body: 'Edited answer body' }, format: :js
        another_answer.reload
        expect(assigns(:answer).body).to eq 'Original answer body'
      end
    end

    context 'Author update own answer' do
      it 'update answer' do
        patch :update, id: answer, question_id: question, answer: { body: 'Edited answer body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'Edited answer body'
      end
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end
end
