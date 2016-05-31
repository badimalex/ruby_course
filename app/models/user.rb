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
      voteable.up_votes += 1
      voteable.save!
    end
  end
end
