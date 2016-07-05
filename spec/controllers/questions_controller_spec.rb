require 'rails_helper'

RSpec.describe QuestionsController do
  it_behaves_like 'Voted'

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'pupulates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, user: create(:user), title: 'Hello world', body: 'Best body question ever') }

    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new comment for question' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before do
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    let(:question) { create(:question) }

    before do
      get :edit, id: question
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
      it 'publish question' do
        expect(PrivatePub).to receive(:publish_to)
        post :create, question: attributes_for(:question)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
      it 'not publish question' do
        expect(PrivatePub).to_not receive(:publish_to)
        post :create, question: attributes_for(:invalid_question)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question) { create(:question, user: @user, title: 'First question title', body: 'First question body') }

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body for question' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body for question'
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author try to edit other user question' do
      let(:another_user) { create(:user) }
      let(:another_question) { create(:question, user: another_user, body: 'Original question body') }

      it 'doesn\'t accept answer' do
        another_question
        patch :update, id: another_question, question: { title: 'new title', body: 'new body for question' }

        another_question.reload
        expect(another_question.body).to eq 'Original question body'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'First question title'
        expect(question.body).to eq 'First question body'
      end

      it 're-renders edit view', js: true do
        expect(response).to render_template :update
      end
    end
  end

  describe 'Delete #destroy' do
    sign_in_user
    let(:question) { create(:question, user: @user) }

    context 'Author deletes own question' do
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'Author deletes another author question' do
      let(:another_user) { create(:user) }
      let(:another_question) { create(:question, user: another_user) }

      it 'doesn\'t deletes a question' do
        another_question
        expect { delete :destroy, id: another_question }.to_not change(Question, :count)
      end

      it 'stay at current_path' do
        delete :destroy, id: another_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
