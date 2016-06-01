class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(entity)
    id == entity.user_id
  end

  def up_vote(voteable)
    if voteable.user_id == id
      raise Exception.new('The voteable cannot be voted by the owner.')
    else
      vote = Vote.where(voteable: voteable, user_id: id).first
      if vote
        if vote.score == 1
          raise Exception.new('The voteable was already voted by the voter.')
        end
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
      raise Exception.new('The voteable cannot be voted by the owner.')
    else
      voteable.down_votes -= 1
      voteable.save!
    end
  end
end
