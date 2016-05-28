class AddScoreColumnToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :score, :integer, default: 0, index: true
  end
end
