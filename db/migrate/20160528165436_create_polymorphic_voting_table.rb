class CreatePolymorphicVotingTable < ActiveRecord::Migration
  def change
    add_column :votings, :voteable_id, :integer
    add_column :votings, :voteable_type, :string
    add_column :votings, :vote, :integer, index: true

    add_index :votings, [:voteable_id, :voteable_type]
  end
end
