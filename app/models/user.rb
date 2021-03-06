class User < ActiveRecord::Base
  TEMP_EMAIL_REGEX = /\Anew@user/
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :subscriptions
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,  omniauth_providers: [:facebook, :twitter]

  def author_of?(entity)
    id == entity.user_id
  end

  def un_vote(voteable)
    vote = Vote.where(voteable: voteable, user_id: id).first
    if vote.score == 1
      voteable.up_votes -=1
    else
      voteable.down_votes -=1
    end
    voteable.save!
    vote.destroy!
  end

  def up_vote(voteable)
    if voteable.user_id == id
      raise Exceptions::OwnerVotedError
    else
      vote = Vote.where(voteable: voteable, user_id: id).first
      if vote
        raise Exceptions::AlreadyVotedError
      else
        vote = Vote.create(voteable: voteable, user_id: id)
      end
      vote.score = 1
      voteable.up_votes += 1
      voteable.save!
      vote.save!
    end
  end

  def down_vote(voteable)
    if voteable.user_id == id
      raise Exceptions::OwnerVotedError
    else
      vote = Vote.where(voteable: voteable, user_id: id).first
      if vote
        raise Exceptions::AlreadyVotedError
      else
        vote = Vote.create(voteable: voteable, user_id: id)
      end
      vote.score = -1
      voteable.down_votes += 1
      voteable.save!
      vote.save!
    end
  end

  def voted?(voteable)
    !Vote.where(voteable: voteable, user_id: id).first.nil?
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s ).first
    return authorization.user if authorization
    email = auth.info[:email] ? auth.info[:email] : "new@user-#{auth.uid}-#{auth.provider}.com"
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0,20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation_notification!
      user.skip_confirmation!
      user.save!
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
