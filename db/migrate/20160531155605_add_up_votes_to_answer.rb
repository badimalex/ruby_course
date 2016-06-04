class AddUpVotesToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :up_votes, :integer, default: 0
  end
end
