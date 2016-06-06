FactoryGirl.define do
  factory :comment do
    body 'MyString'
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end
end
