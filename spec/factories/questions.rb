FactoryGirl.define do
  factory :question do
    title 'Hello world'
    body 'files took 7.21 seconds to load'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user nil
  end
end
