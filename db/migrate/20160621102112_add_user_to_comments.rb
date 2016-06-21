class AddUserToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :user
  end
end
