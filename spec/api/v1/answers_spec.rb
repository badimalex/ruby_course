require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end
    end
  end
end
