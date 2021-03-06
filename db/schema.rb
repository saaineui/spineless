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

ActiveRecord::Schema.define(version: 2020_03_21_214442) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer "book_id"
    t.integer "location"
    t.decimal "scroll", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["book_id"], name: "index_bookmarks_on_book_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author"
    t.string "logo_url"
    t.text "epigraph"
    t.text "copyright"
    t.string "background_image_url"
    t.string "cover_image_url"
    t.integer "text_length"
    t.string "subtitle"
    t.text "sample"
    t.integer "sections_count", default: 0
    t.integer "chapters_count", default: 0
    t.integer "hidden", default: 0
    t.integer "featured", default: 0
  end

  create_table "sections", force: :cascade do |t|
    t.string "title"
    t.integer "order"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "indexable", default: false
    t.integer "chapter"
    t.integer "book_id"
    t.index ["book_id"], name: "index_sections_on_book_id"
    t.index ["chapter"], name: "index_sections_on_chapter"
    t.index ["order"], name: "index_sections_on_order"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
