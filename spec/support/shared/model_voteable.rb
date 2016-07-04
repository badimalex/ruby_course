shared_examples_for 'Model voteable' do
  describe '#rating' do
    let(:user) { create(:user) }
    subject { create(described_class.to_s.downcase.to_sym, up_votes: 5, down_votes: 3) }
    it 'should return correct voteable rating' do
      expect(subject.rating).to eq(2)
    end
  end
end
