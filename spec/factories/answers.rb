FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "My awesome answer body#{n}" }
    question
    user
  end
end
