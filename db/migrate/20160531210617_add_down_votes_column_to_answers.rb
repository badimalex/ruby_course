class AddDownVotesColumnToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :down_votes, :integer, default: 0
  end
end
