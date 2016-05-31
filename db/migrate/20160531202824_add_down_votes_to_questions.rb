class AddDownVotesToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :down_votes, :integer, default: 0
  end
end
