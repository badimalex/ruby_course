require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create :question }
    let(:answer) { create :answer }

    context 'with valid attributes' do
      it 'saves the new comment for question' do
        expect { post :create, question_id: question, comment: attributes_for(:comment) }
            .to change(question.comments, :count).by(1)
      end

      it 'saves the new comment for answer' do
        expect { post :create, answer_id: answer, comment: attributes_for(:comment) }
            .to change(answer.comments, :count).by(1)
      end

      xit 'redirects to question show view' do
        post :create, question_id: question, comment: attributes_for(:comment)
        expect(response).to redirect_to question_path(question)
      end

      xit 'associates comment with question' do
        expect { post :create, question_id: question, comment: attributes_for(:comment) }
            .to change(question.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      xit 'does not save comment' do
        expect { post :create, question_id: question, comment: attributes_for(:invalid_comment), format: :js }
            .to_not change(Comment, :count)
      end

      xit 're-renders new view' do
        post :create, question_id: question, comment: attributes_for(:invalid_comment)
        expect(response).to render_template :new
      end
    end
  end
end
