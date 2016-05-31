class AddColumnsToVote < ActiveRecord::Migration
  def change
    add_reference :votes, :user
    add_reference :votes, :voteable, polymorphic: true
    add_column :votes, :score, :integer, default: 0

    add_index :votes, [:voteable_type, :voteable_id]
  end
end
