class AddIndexForQuestionScore < ActiveRecord::Migration
  def change
    add_index :questions, :score
  end
end
