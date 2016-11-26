class AddExplicitlyIndexedToDirectories < ActiveRecord::Migration
  def change
    add_column :directories, :explicitly_indexed, :boolean, default: false
  end
end
