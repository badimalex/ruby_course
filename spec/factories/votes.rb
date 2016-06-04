FactoryGirl.define do
  factory :vote, class: 'Vote' do
    score 1
    user
  end
end
