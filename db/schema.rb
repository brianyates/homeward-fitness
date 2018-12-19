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

ActiveRecord::Schema.define(version: 20180523180124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_workouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "workout_id"
  end

  create_table "alerts", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "read",         default: false
    t.string   "redirect_url"
    t.integer  "image_user"
    t.string   "image_path"
  end

  create_table "avatars", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "image"
    t.integer  "user_id"
    t.integer  "avatar_type",   default: 0
    t.integer  "instructor_id"
  end

  create_table "badges", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "badge_name"
    t.string   "badge_description"
    t.string   "image_path"
  end

  create_table "comment_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "comment_id"
    t.index ["comment_id", "user_id"], name: "index_comment_likes_on_comment_id_and_user_id", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "thing_id"
    t.index ["thing_id"], name: "index_comments_on_thing_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "email"
    t.string   "name"
    t.string   "content"
    t.integer  "category"
    t.boolean  "resolved",   default: false
  end

  create_table "contest_stagings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "inviter_id"
    t.string   "email"
    t.integer  "contest_id"
    t.index ["email", "contest_id"], name: "index_contest_stagings_on_email_and_contest_id", unique: true, using: :btree
  end

  create_table "contestants", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "contest_id"
    t.integer  "user_id"
    t.integer  "status",     default: 0
    t.integer  "inviter_id"
    t.index ["user_id", "contest_id"], name: "index_contestants_on_user_id_and_contest_id", unique: true, using: :btree
  end

  create_table "contests", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "owner_id"
    t.string   "contest_title"
    t.boolean  "owner_invite_only", default: false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "thing_id"
  end

  create_table "earned_badges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "badge_id"
    t.integer  "user_id"
    t.index ["user_id", "badge_id"], name: "index_earned_badges_on_user_id_and_badge_id", unique: true, using: :btree
  end

  create_table "email_preferences", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.string   "token_1"
    t.string   "token_2"
    t.integer  "contest_info",       default: 1
    t.integer  "contest_invitation", default: 1
    t.integer  "new_badge",          default: 1
    t.integer  "contest_comments",   default: 1
    t.integer  "leaderboard",        default: 1
    t.integer  "friend_requests",    default: 1
    t.integer  "post_info",          default: 1
    t.integer  "comment_replies",    default: 1
    t.index ["user_id"], name: "index_email_preferences_on_user_id", using: :btree
  end

  create_table "email_tokens", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "password_digest"
  end

  create_table "exercises", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "workout_id"
    t.integer  "points_per_rep"
    t.string   "exercise_description"
    t.integer  "reps_per_round"
  end

  create_table "friends", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "status",        default: 0
    t.integer  "paired_record"
    t.index ["user_id", "friend_id"], name: "index_friends_on_user_id_and_friend_id", unique: true, using: :btree
  end

  create_table "instructor_tokens", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "instructor_id"
    t.string   "password_digest"
    t.integer  "user_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "instructor_name"
    t.string   "image_path"
    t.string   "website_url"
    t.string   "address"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "about_me"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "thing_id"
    t.index ["thing_id", "user_id"], name: "index_likes_on_thing_id_and_user_id", unique: true, using: :btree
    t.index ["thing_id"], name: "index_likes_on_thing_id", using: :btree
  end

  create_table "password_tokens", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "password_digest"
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "workout_id"
    t.integer  "user_id"
    t.string   "comment"
    t.string   "video_url"
    t.integer  "seconds"
    t.integer  "thing_id"
    t.string   "image"
    t.boolean  "active_workout", default: false
  end

  create_table "replies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "comment_id"
  end

  create_table "reply_emails", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "comment_id"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.index ["comment_id", "user_id", "recipient_id"], name: "reply_email_index", unique: true, using: :btree
  end

  create_table "reply_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "reply_id"
    t.index ["reply_id", "user_id"], name: "index_reply_likes_on_reply_id_and_user_id", unique: true, using: :btree
  end

  create_table "results", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "reps"
    t.integer  "post_id"
    t.integer  "exercise_id"
    t.integer  "total_points"
  end

  create_table "stagings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "email"
  end

  create_table "thing_emails", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "thing_id"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.integer  "category"
    t.index ["thing_id", "user_id", "recipient_id", "category"], name: "thing_email_index", unique: true, using: :btree
  end

  create_table "things", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "thing_type"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "email"
    t.string   "provider"
    t.string   "name"
    t.string   "provider_uid"
    t.integer  "privacy_setting", default: 0
    t.integer  "gender",          default: 0
    t.string   "image_path"
    t.integer  "emoji_value"
    t.boolean  "email_validated", default: false
    t.integer  "instructor_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "workouts", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "video_url"
    t.boolean  "active_flag",         default: false
    t.integer  "duration"
    t.string   "difficulty"
    t.integer  "workout_type"
    t.string   "workout_description"
    t.string   "workout_title"
    t.string   "required_equipment"
    t.string   "point_cutoffs"
    t.integer  "points_per_workout"
    t.string   "custom_note"
    t.integer  "thing_id"
    t.string   "image"
    t.integer  "instructor_id"
    t.boolean  "rounds_and_reps",     default: false
  end

end
