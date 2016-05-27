class AddScoreColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :score, :integer, default: 0
  end
end
