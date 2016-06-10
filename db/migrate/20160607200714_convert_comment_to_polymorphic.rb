class ConvertCommentToPolymorphic < ActiveRecord::Migration
  def change
    remove_column :comments, :question_id
    add_reference :comments, :commentable, polymorphic: true
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
