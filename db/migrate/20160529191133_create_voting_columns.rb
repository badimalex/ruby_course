class CreateVotingColumns < ActiveRecord::Migration
  def change
    add_column :votings, :voteable_type, :string
    add_column :votings, :voteable_id, :integer
    add_column :votings, :score, :integer, default: 0
    add_reference :votings, :user, index: true, foreign_key: true

    add_index :votings, [:voteable_type, :voteable_id]
  end

  def down
    drop_table :votings
  end
end
