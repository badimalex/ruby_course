class AddUserForeignKeyToVotings < ActiveRecord::Migration
  def change
    add_belongs_to :votings, :user, index: true, foreign_key: true
  end
end
