require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, user: @user, question: question) }
  let!(:other_question) { create(:question, user: create(:user)) }
  let!(:attachment) { create(:attachment) }
  let!(:other_attachment) { create(:attachment) }
  let!(:other_answer) { create(:answer, user: create(:user), question: other_question) }

  describe 'Delete #destroy' do
    context 'Author deletes own question file' do
      before do
        question.attachments.push attachment
      end

      it 'assign attachment to @attachment' do
        delete :destroy, id: attachment, format: :js
        expect(assigns(:attachment)).to eq attachment
      end

      it 'deletes file' do
        expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
      end
    end

    context 'Author delete other author question file' do
      before do
        other_question.attachments.push other_attachment
      end

      it 'doesnt deletes file' do
        expect { delete :destroy, id: other_attachment, format: :js }.to_not change(Attachment, :count)
      end

      it 'stay at current_path' do
        delete :destroy, id: other_attachment, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'Author delete own answer file' do
      before do
        answer.attachments.push attachment
      end

      it 'deletes file' do
        expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
      end
    end

    context 'Author delete other answer file' do
      before do
        other_answer.attachments.push other_attachment
      end

      it 'doesnt deletes file' do
        expect { delete :destroy, id: other_attachment, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
