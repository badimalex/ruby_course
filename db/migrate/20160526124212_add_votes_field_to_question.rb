class AddVotesFieldToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :votes, :integer, default: 0
    add_index :questions, :votes
  end
end
