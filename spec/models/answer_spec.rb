require 'rails_helper'

describe Answer do
  it { should belong_to(:question) }

  it { should validate_presence_of(:question_id) }

  it 'is invalid without a body' do
    answer = Answer.new(body: nil)
    expect(answer).to be_invalid
  end

  it 'is invalid when body < 10' do
    answer = Answer.new(body: 'lorem')
    answer.valid?
    expect(answer.errors[:body].size).to eq(1)
  end

  it 'is valid with a question_id and body' do
    answer = Answer.new(
      question_id: 1,
      body: 'Lorem Ipsum is simply dummy text of the printing')
    expect(answer).to be_valid
  end
end
