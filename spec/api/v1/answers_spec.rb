require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'
    let(:question) { create(:question) }

    context 'unauthorized' do
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
      let!(:answers) { create_list(:answer, 2, question: question) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end
    end
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:attachment) { create(:attachment, attachmentable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it 'attachment object contain file url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file/url")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }

    context 'authorized' do
      context 'when is successfully created' do
        before do
          answer = create(:answer, question: question)
          @answer_attributes = attributes_for :answer
          post "/api/v1/questions/#{question.id}/answers", answer: @answer_attributes, format: :json, access_token: access_token.token
        end

        it 'returns 201 status code' do
          expect(response).to have_http_status(:created)
        end

        it 'answer object contains body' do
          expect(response.body).to be_json_eql(@answer_attributes[:body].to_json).at_path('body')
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
