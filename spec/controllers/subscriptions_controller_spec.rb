require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }
    let(:question) { create :question }
    before { user.questions << question }

    context 'authorized' do
      sign_in_user
      context 'when not subscribed' do
        it 'creates subscription' do
          expect { post :create, question_id: question.id, format: :js }
              .to change(@user.subscriptions, :count).by 1
        end

        it 'returns status 200' do
          post :create, question_id: question.id, format: :js
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, question: question,  user: user) }

    context 'Non authorized' do
      sign_in_user
      before { @user.subscriptions << subscription }

      it 'returns status 200' do
        delete :destroy, question_id: question, id: subscription, format: :js
        expect(response.status).to eq 200
      end

      it 'destroys subscription' do
        expect { delete :destroy, question_id: question, id: subscription, format: :js }
            .to change(@user.subscriptions, :count).by(-1)
      end
    end
  end
end
