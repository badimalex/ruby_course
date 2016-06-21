class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :destroy, Question, user: user

    can :up_vote, Question do |question|
      question.try(:user) != user
    end

    can :un_vote, Question do |question|
      question.try(:user) != user
    end

    can :down_vote, Question do |question|
      question.try(:user) != user
    end
  end
end
