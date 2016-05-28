class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|

      t.timestamps
    end
  end
end
