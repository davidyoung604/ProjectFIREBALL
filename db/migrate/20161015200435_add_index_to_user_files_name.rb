class AddIndexToUserFilesName < ActiveRecord::Migration
  def change
    add_index :user_files, :name
  end
end
