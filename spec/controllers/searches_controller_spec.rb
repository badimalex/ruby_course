require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
      expect(response.status).to eq 200
    end

    it 'Assign search attributes to model' do
      query = 'string'
      section = Search::SECTIONS.first
      expect(Search).to receive(:find).with(query, section)
      get :index, query: query, section: section
    end
  end
end
