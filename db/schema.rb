# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100708163841) do

  create_table "assignments", :force => true do |t|
    t.integer  "chore_list_id"
    t.integer  "task_id"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "worker_id",                               :null => false
    t.date     "date_complete", :default => '2000-01-01'
  end

  create_table "chore_lists", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "worker_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.date     "date",       :default => '2000-01-01'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "recorded",   :default => false
    t.integer  "duration",   :default => 60
  end

  create_table "plans_workers", :id => false, :force => true do |t|
    t.integer "plan_id",   :null => false
    t.integer "worker_id", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.date     "last_date"
    t.date     "next_date"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurrance",     :default => 1
    t.integer  "priority",       :default => 5
    t.date     "scheduled_date", :default => '2000-01-01'
  end

  create_table "tasks_workers", :id => false, :force => true do |t|
    t.integer "task_id",   :null => false
    t.integer "worker_id", :null => false
  end

  create_table "workers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_chores",                               :default => false
    t.decimal  "pay_rate",   :precision => 8, :scale => 2, :default => 0.0
  end

end
