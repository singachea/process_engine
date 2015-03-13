# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150313063633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "process_engine_process_definitions", force: :cascade do |t|
    t.string   "name"
    t.string   "slug",                       null: false
    t.string   "starting_node"
    t.text     "description"
    t.text     "bpmn_xml"
    t.jsonb    "bpmn_json",     default: {}
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "process_engine_process_instances", force: :cascade do |t|
    t.integer  "status",                default: 0
    t.string   "states",                default: [],              array: true
    t.string   "creator"
    t.integer  "process_definition_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "process_engine_process_instances", ["creator"], name: "index_process_engine_process_instances_on_creator", using: :btree
  add_index "process_engine_process_instances", ["process_definition_id"], name: "index_process_engine_process_instances_on_process_definition_id", using: :btree
  add_index "process_engine_process_instances", ["states"], name: "index_process_engine_process_instances_on_states", using: :gin

  create_table "process_engine_process_tasks", force: :cascade do |t|
    t.string   "assignee"
    t.string   "candidate_users",     default: [],              array: true
    t.string   "candidate_groups",    default: [],              array: true
    t.integer  "status",              default: 0
    t.jsonb    "data",                default: {}
    t.string   "finisher"
    t.string   "state"
    t.integer  "process_instance_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "process_engine_process_tasks", ["assignee"], name: "index_process_engine_process_tasks_on_assignee", using: :btree
  add_index "process_engine_process_tasks", ["candidate_groups"], name: "index_process_engine_process_tasks_on_candidate_groups", using: :gin
  add_index "process_engine_process_tasks", ["candidate_users"], name: "index_process_engine_process_tasks_on_candidate_users", using: :gin
  add_index "process_engine_process_tasks", ["data"], name: "index_process_engine_process_tasks_on_data", using: :gin
  add_index "process_engine_process_tasks", ["finisher"], name: "index_process_engine_process_tasks_on_finisher", using: :btree
  add_index "process_engine_process_tasks", ["process_instance_id"], name: "index_pept_piid", using: :btree
  add_index "process_engine_process_tasks", ["state"], name: "index_process_engine_process_tasks_on_state", using: :btree

  add_foreign_key "process_engine_process_instances", "process_engine_process_definitions", column: "process_definition_id"
  add_foreign_key "process_engine_process_tasks", "process_engine_process_instances", column: "process_instance_id"
end
