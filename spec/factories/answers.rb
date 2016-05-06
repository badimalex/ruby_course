FactoryGirl.define do
  factory :answer do
    body 'by best body answer in life'
    question
    # а что если мы используем эту фабрику для незалогинненого юзера
    # например в /spec/features/question/show_question_spec.rb
    # не будет лишним добавлению юзера тут?
    user
  end
end
