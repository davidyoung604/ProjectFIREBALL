class AddIndexToDirectoriesName < ActiveRecord::Migration
  def change
    add_index :directories, :name, unique: true
  end
end
