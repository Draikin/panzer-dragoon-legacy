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

ActiveRecord::Schema.define(version: 20150928125816) do

  create_table "articles", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "content"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.string   "category_type"
    t.boolean  "publish"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "category_group_id"
  end

  create_table "category_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "category_group_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer  "story_id"
    t.string   "chapter_type", default: "regular_chapter"
    t.integer  "number",       default: 1
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "contributions", force: :cascade do |t|
    t.integer  "contributor_profile_id"
    t.integer  "contributable_id"
    t.string   "contributable_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "contributor_profiles", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "email_address"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "website"
    t.string   "facebook_username"
    t.string   "twitter_username"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "discourse_username"
  end

  create_table "downloads", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "download_file_name"
    t.string   "download_content_type"
    t.integer  "download_file_size"
    t.datetime "download_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "emoticons", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "emoticon_file_name"
    t.string   "emoticon_content_type"
    t.integer  "emoticon_file_size"
    t.datetime "emoticon_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "encyclopaedia_entries", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "information"
    t.text     "content"
    t.string   "encyclopaedia_entry_picture_file_name"
    t.string   "encyclopaedia_entry_picture_content_type"
    t.integer  "encyclopaedia_entry_picture_file_size"
    t.datetime "encyclopaedia_entry_picture_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "illustrations", force: :cascade do |t|
    t.integer  "illustratable_id"
    t.string   "illustratable_type"
    t.string   "illustration_file_name"
    t.string   "illustration_content_type"
    t.integer  "illustration_file_size"
    t.datetime "illustration_updated_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "links", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.integer  "category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "partner_site", default: false
  end

  create_table "music_tracks", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "mp3_music_track_file_name"
    t.string   "mp3_music_track_content_type"
    t.integer  "mp3_music_track_file_size"
    t.datetime "mp3_music_track_updated_at"
    t.string   "ogg_music_track_file_name"
    t.string   "ogg_music_track_content_type"
    t.integer  "ogg_music_track_file_size"
    t.datetime "ogg_music_track_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "track_number",                  default: 0
    t.string   "flac_music_track_file_name"
    t.string   "flac_music_track_content_type"
    t.integer  "flac_music_track_file_size"
    t.datetime "flac_music_track_updated_at"
  end

  create_table "news_entries", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.integer  "contributor_profile_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "published_at"
    t.string   "short_url"
    t.boolean  "publish"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "poems", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "quiz_answers", force: :cascade do |t|
    t.integer  "quiz_question_id"
    t.text     "content"
    t.boolean  "correct_answer",   default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.integer  "quiz_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quizzes", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.boolean  "publish"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "relations", force: :cascade do |t|
    t.integer  "encyclopaedia_entry_id"
    t.integer  "relatable_id"
    t.string   "relatable_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sagas", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "sequence_number",        default: 1
    t.integer  "encyclopaedia_entry_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "sagas", ["encyclopaedia_entry_id"], name: "index_sagas_on_encyclopaedia_entry_id"

  create_table "stories", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "administrator",          default: false
    t.integer  "contributor_profile_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

  create_table "videos", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "mp4_video_file_name"
    t.string   "mp4_video_content_type"
    t.integer  "mp4_video_file_size"
    t.datetime "mp4_video_updated_at"
    t.string   "webm_video_file_name"
    t.string   "webm_video_content_type"
    t.integer  "webm_video_file_size"
    t.datetime "webm_video_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "youtube_video_id"
  end

end
