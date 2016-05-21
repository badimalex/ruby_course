require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  # let(:question) { create(:question) }
  let!(:attachment) { create(:attachment) }

  describe 'Delete #destroy' do
    context 'Author deletes own answer attachment file' do
      it 'assign attachment to @attachment' do
        delete :destroy, id: attachment, format: :js
        expect(assigns(:attachment)).to eq attachment
      end

      it 'deletes file' do
        expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
      end
    end
  end
end
