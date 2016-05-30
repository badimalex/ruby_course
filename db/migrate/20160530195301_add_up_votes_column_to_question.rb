class AddUpVotesColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :up_votes, :integer, default: 0
  end
end
