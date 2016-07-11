require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '#find' do

    query = 'string'
    section = Search::SECTIONS.first

    it 'calls search method on model' do
      expect(Question).to receive(:search).with(query)
      Search.find(query, section)
    end
  end
end
