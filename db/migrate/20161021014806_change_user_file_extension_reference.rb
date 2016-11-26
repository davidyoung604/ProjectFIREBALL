class ChangeUserFileExtensionReference < ActiveRecord::Migration
  def change
    add_reference :user_files, :extension, index: true, foreign_key: true
  end
end
