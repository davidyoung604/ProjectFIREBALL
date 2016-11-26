class AddDirectoryToUserFile < ActiveRecord::Migration
  def change
    add_reference :user_files, :directory, index: true, foreign_key: true
  end
end
