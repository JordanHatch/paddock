# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_08_131505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "commitments", force: :cascade do |t|
    t.bigint "quarter_id", null: false
    t.integer "number"
    t.string "name", null: false
    t.text "overview"
    t.text "benefits", default: [], array: true
    t.text "actions", default: [], array: true
    t.text "commodities", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "key_commitment", default: false, null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_commitments_on_group_id"
    t.index ["quarter_id"], name: "index_commitments_on_quarter_id"
  end

  create_table "exported_sprint_reports", force: :cascade do |t|
    t.bigint "sprint_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sprint_id"], name: "index_exported_sprint_reports_on_sprint_id"
    t.index ["user_id"], name: "index_exported_sprint_reports_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "good_jobs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at", precision: nil
    t.datetime "performed_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.text "error"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "update_id", null: false
    t.text "description"
    t.text "treatment"
    t.text "help"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.index ["update_id"], name: "index_issues_on_update_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "revoked_at", precision: nil
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "quarters", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.date "start_on", null: false
    t.date "end_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "editable", default: true, null: false
    t.index ["slug"], name: "index_quarters_on_slug", unique: true
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_on", null: false
    t.date "end_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_label"
  end

  create_table "team_commitments", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "commitment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_id"], name: "index_team_commitments_on_commitment_id"
    t.index ["team_id"], name: "index_team_commitments_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "group_id"
    t.date "start_on"
    t.date "end_on"
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "updates", force: :cascade do |t|
    t.text "content"
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "delivery_status"
    t.string "team_health"
    t.integer "current_headcount"
    t.text "sprint_goals", default: [], array: true
    t.text "next_sprint_goals", default: [], array: true
    t.integer "sprint_id", null: false
    t.string "state", default: "not_started"
    t.integer "vacant_roles"
    t.string "okr_status"
    t.index ["sprint_id", "team_id"], name: "index_updates_on_sprint_id_and_team_id", unique: true
    t.index ["team_id"], name: "index_updates_on_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user", null: false
    t.string "name"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "commitments", "groups", on_delete: :restrict
  add_foreign_key "commitments", "quarters"
  add_foreign_key "exported_sprint_reports", "sprints"
  add_foreign_key "exported_sprint_reports", "users"
  add_foreign_key "issues", "updates", on_delete: :cascade
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "team_commitments", "commitments"
  add_foreign_key "team_commitments", "teams"
  add_foreign_key "teams", "groups", on_delete: :restrict
  add_foreign_key "updates", "sprints", on_delete: :restrict
  add_foreign_key "updates", "teams"

  create_view "team_summaries", sql_definition: <<-SQL
      SELECT t.id,
      s.id AS sprint_id,
      u.id AS update_id,
      t.name,
      t.start_on,
      t.slug,
      t.group_id,
      u.state,
      u.delivery_status,
      u.okr_status,
      ( SELECT count(*) AS count
             FROM issues i
            WHERE (i.update_id = u.id)) AS issue_count
     FROM ((sprints s
       JOIN teams t ON ((((t.start_on <= s.end_on) OR (t.start_on IS NULL)) AND ((t.end_on >= s.end_on) OR (t.end_on IS NULL)))))
       LEFT JOIN updates u ON (((u.sprint_id = s.id) AND (u.team_id = t.id))));
  SQL
end
