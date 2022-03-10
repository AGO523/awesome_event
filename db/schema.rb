ActiveRecord::Schema.define(version: 2022_03_08_212631) do

  create_table "events", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name", null: false
    t.string "place", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_events_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"provider,\", \"uid\"", name: "index_users_on_provider,_and_uid", unique: true
  end

end
