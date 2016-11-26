class AddTagsUserFiles < ActiveRecord::Migration
  def change
    create_join_table :tags, :user_files do |t|
      t.index :tag_id
      t.index :user_file_id
    end
  end
end
