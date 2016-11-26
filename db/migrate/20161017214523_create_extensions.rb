class CreateExtensions < ActiveRecord::Migration
  def change
    create_table :extensions do |t|
      t.string :name
      t.belongs_to :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
