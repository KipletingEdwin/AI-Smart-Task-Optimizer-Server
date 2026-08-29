
ActiveRecord::Schema[8.1].define(version: 2026_08_28_202032) do
  create_table "subtasks", force: :cascade do |t|
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "estimated_minutes"
    t.integer "position"
    t.integer "task_id", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_subtasks_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "subtasks", "tasks"
  add_foreign_key "tasks", "users"
end
