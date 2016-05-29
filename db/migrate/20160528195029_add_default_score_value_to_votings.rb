class AddDefaultScoreValueToVotings < ActiveRecord::Migration
  def change
    change_column_default :votings, :vote, 0
  end
end
