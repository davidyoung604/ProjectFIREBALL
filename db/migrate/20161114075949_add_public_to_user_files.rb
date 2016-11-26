class AddPublicToUserFiles < ActiveRecord::Migration
  def change
    add_column :user_files, :public, :boolean, default: false
  end
end
