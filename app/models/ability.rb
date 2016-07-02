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

    can :up_vote, [Question, Answer] do |voteable|
      voteable.try(:user_id) != user.id
    end

    can :un_vote, [Question, Answer] do |voteable|
      voteable.try(:user_id) != user.id
    end

    can :down_vote, [Question, Answer] do |voteable|
      voteable.try(:user_id) != user.id
    end
  end
end
