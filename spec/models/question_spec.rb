require 'rails_helper'

describe Question do
  it { should have_many(:answers) }

  it 'is invalid without a title' do
    question = Question.new(title: nil)
    expect(question).to be_invalid
  end

  it 'is invalid when title < 5' do
    question = Question.new(title: 'min')
    question.valid?
    expect(question.errors[:title].size).to eq(1)
  end

  it 'is invalid without a body' do
    question = Question.new(body: nil)
    expect(question).to be_invalid
  end

  it 'is invalid when body < 15' do
    question = Question.new(body: 'lorem ipsum')
    question.valid?
    expect(question.errors[:body].size).to eq(1)
  end

  it 'is valid with a title and body' do
    question = Question.new(
      title: 'Question',
      body: 'Lorem Ipsum is simply dummy text of the printing')
    expect(question).to be_valid
  end
end
