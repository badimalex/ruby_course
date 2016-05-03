FactoryGirl.define do
  factory :question do
    title 'Hello world'
    body 'files took 7.21 seconds to load'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
