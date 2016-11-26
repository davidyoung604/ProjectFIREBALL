class AddUserToUserFiles < ActiveRecord::Migration
  def change
    add_reference :user_files, :user, index: true, foreign_key: true
  end
end
