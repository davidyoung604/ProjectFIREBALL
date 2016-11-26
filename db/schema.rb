# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161119232339) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "directories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "explicitly_indexed", default: false
    t.integer  "parent_id"
    t.index ["name"], name: "index_directories_on_name", unique: true
  end

  create_table "extensions", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_extensions_on_category_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tags_user_files", id: false, force: :cascade do |t|
    t.integer "tag_id",       null: false
    t.integer "user_file_id", null: false
    t.index ["tag_id"], name: "index_tags_user_files_on_tag_id"
    t.index ["user_file_id"], name: "index_tags_user_files_on_user_file_id"
  end

  create_table "user_files", force: :cascade do |t|
    t.string   "name"
    t.bigint   "size"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "directory_id"
    t.integer  "extension_id"
    t.integer  "user_id"
    t.boolean  "public",       default: false
    t.index ["directory_id"], name: "index_user_files_on_directory_id"
    t.index ["extension_id"], name: "index_user_files_on_extension_id"
    t.index ["name"], name: "index_user_files_on_name"
    t.index ["user_id"], name: "index_user_files_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
