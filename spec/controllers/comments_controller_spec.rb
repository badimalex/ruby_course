require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create :question }
    let(:answer) { create :answer }

    context 'with valid attributes' do
      it 'saves the new comment for question' do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :js }
          .to change(question.comments, :count).by(1)
      end

      it 'saves the new comment for answer' do
        expect { post :create, answer_id: answer, comment: attributes_for(:comment) }
          .to change(answer.comments, :count).by(1)
      end

      it 're-renders new view for question' do
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to render_template :create
      end
    end
  end
end
