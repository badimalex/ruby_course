require 'rails_helper'

RSpec.describe Search, type: :model do
  %w(everywhere questions answers comments users).each do |section|
    it "sections contains #{section}" do
      Search::SECTIONS.should include(section)
    end
  end

  describe '#find' do
    context 'when search with model class' do
      section = 'questions'
      it 'search with object model class' do
        expect(Question).to receive(:search).with('string')
        Search.find('string', section)
      end
    end

    context 'when search everywhere' do
      section = 'everywhere'
      it 'search with ThinkingSphinx' do
        expect(ThinkingSphinx).to receive(:search).with('string')
        Search.find('string', section)
      end

      it 'not search with object model class' do
        expect(Question).to_not receive(:search).with('string')
        Search.find('string', section)
      end
    end

    context 'with non exists section' do
      it 'raise exception' do
        expect { Search.find('string', 'non_exist_section') }.to raise_error(Exceptions::NonExistSection)
      end
    end
  end
end
