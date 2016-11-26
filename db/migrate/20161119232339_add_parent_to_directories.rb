class AddParentToDirectories < ActiveRecord::Migration
  def change
    add_reference :directories, :parent, foreign_key: { to_table: :directories }
  end
end
