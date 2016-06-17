class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

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

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s ).first
    return authorization.user if authorization
    email = auth.info[:email]
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
