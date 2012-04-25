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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120405151636) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "comments"
    t.date     "done_by_date"
    t.boolean  "done"
    t.integer  "default_activity_id"
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_reminders", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days_before"
    t.boolean  "sent"
  end

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.integer  "commune_id"
  end

  create_table "ages", :force => true do |t|
    t.string   "range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attached_files", :force => true do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "attached_file_name"
    t.string   "attached_content_type"
    t.integer  "attached_file_size"
    t.datetime "attached_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachednotes", :force => true do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_comments", :force => true do |t|
    t.string   "name"
    t.text     "comment"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.string   "status"
    t.string   "bookable_type"
    t.integer  "bookable_id"
    t.integer  "user_account_id"
    t.integer  "supplier_account_id"
    t.text     "message"
    t.string   "read"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bride_images", :force => true do |t|
    t.integer  "bride_id"
    t.string   "bride_file_name"
    t.string   "bride_content_type"
    t.integer  "bride_file_size"
    t.datetime "bride_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brides", :force => true do |t|
    t.string   "name"
    t.string   "lastname_p"
    t.string   "lastname_m"
    t.string   "rut"
    t.date     "born_date"
    t.string   "email"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "profession"
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
  end

  create_table "budget_distribution_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_invitation_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_invitee_counts", :force => true do |t|
    t.integer  "user_account_id"
    t.integer  "budget_invitation_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "groom",                     :default => 100
    t.integer  "bride",                     :default => 100
    t.integer  "g_parents",                 :default => 100
    t.integer  "b_parents",                 :default => 100
  end

  create_table "budget_ranges", :force => true do |t|
    t.string   "range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_slots", :force => true do |t|
    t.integer  "industry_category_id"
    t.integer  "budget_distribution_type_id"
    t.integer  "user_account_id"
    t.integer  "budget_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budgets", :force => true do |t|
    t.integer  "user_account_id"
    t.string   "budgetable_type"
    t.integer  "budgetable_id"
    t.integer  "budget_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "industry_category_id"
    t.string   "industry_category_name"
    t.string   "supplier_account_fantasy_name"
    t.integer  "supplier_account_id"
    t.integer  "price"
    t.integer  "budget_invitation_type_id"
    t.integer  "budget_slot_id"
  end

  create_table "campaign_anecdote_images", :force => true do |t|
    t.string   "anecdote_file_name"
    t.integer  "anecdote_file_size"
    t.string   "anecdote_content_type"
    t.datetime "anecdote_updated_at"
    t.integer  "campaign_anecdote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_anecdotes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "campaign_anecdotes", ["slug"], :name => "index_campaign_anecdotes_on_slug"

  create_table "campaign_gallery_item_images", :force => true do |t|
    t.string   "gallery_item_file_name"
    t.string   "gallery_item_content_type"
    t.integer  "gallery_item_file_size"
    t.datetime "gallery_item_updated_at"
    t.integer  "campaign_gallery_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_gallery_items", :force => true do |t|
    t.string   "tag"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_user_account_infos", :force => true do |t|
    t.integer  "user_account_id"
    t.boolean  "approved_by_us",                   :default => false
    t.text     "description"
    t.string   "campaign_user_image_file_name"
    t.integer  "campaign_user_image_file_size"
    t.string   "campaign_user_image_content_type"
    t.datetime "campaign_user_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ceremonies", :force => true do |t|
    t.integer  "address_id"
    t.string   "phone_number"
    t.string   "contact_email"
    t.string   "contact_person"
    t.string   "schedule"
    t.integer  "capacity"
    t.text     "additional_information"
    t.decimal  "price",                  :precision => 10, :scale => 0
    t.decimal  "top_price_range",        :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ceremony_type_id"
    t.string   "name"
  end

  create_table "ceremony_day_hours", :force => true do |t|
    t.integer  "ceremony_day_id"
    t.time     "hour"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ceremony_days", :force => true do |t|
    t.integer  "ceremony_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ceremony_images", :force => true do |t|
    t.integer  "ceremony_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ceremony_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "color_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communes", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "supplier_account_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "conversable_type"
    t.integer  "conversable_id"
  end

  create_table "couples", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cua_votes", :force => true do |t|
    t.integer  "campaign_user_account_info_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "days", :force => true do |t|
    t.integer  "day_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "weeks_length", :precision => 10, :scale => 0
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_invitee_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dress_images", :force => true do |t|
    t.string   "dress_file_name"
    t.string   "dress_content_type"
    t.integer  "dress_file_size"
    t.datetime "dress_updated_at"
    t.integer  "dress_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dresses", :force => true do |t|
    t.string   "description"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "independent",         :default => false
    t.string   "seller_name"
    t.string   "seller_phone_number"
    t.string   "seller_email"
  end

  create_table "events", :force => true do |t|
    t.integer  "service_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "supplier_account_id"
    t.boolean  "booking_confirmed"
    t.integer  "user_account_id"
    t.boolean  "expired"
    t.integer  "user_id"
    t.boolean  "user_read",           :default => false
    t.string   "email"
    t.boolean  "related_confirm",     :default => false
    t.boolean  "supplier_read"
    t.boolean  "unconfirmed",         :default => false
    t.boolean  "watch",               :default => true
    t.boolean  "soft_deleted",        :default => false
  end

  create_table "expenses", :force => true do |t|
    t.integer  "user_account_id"
    t.integer  "supplier_account_id"
    t.integer  "product_id"
    t.integer  "service_id"
    t.integer  "price"
    t.string   "price_description"
    t.integer  "quantity"
    t.decimal  "payed_percentage",              :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "industry_category_name"
    t.string   "supplier_account_fantasy_name"
    t.integer  "industry_category_id"
    t.boolean  "wants_points",                                                 :default => false
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "genders", :force => true do |t|
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groom_images", :force => true do |t|
    t.integer  "groom_id"
    t.string   "groom_file_name"
    t.string   "groom_content_type"
    t.integer  "groom_file_size"
    t.datetime "groom_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grooms", :force => true do |t|
    t.string   "name"
    t.string   "lastname_p"
    t.string   "lastname_m"
    t.string   "rut"
    t.date     "born_date"
    t.string   "email"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "profession"
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
  end

  create_table "important_dates", :force => true do |t|
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "date_name"
    t.datetime "ends_date"
    t.boolean  "locked"
    t.integer  "supplier_account_id"
    t.string   "custom_message"
  end

  create_table "industry_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "industry_category_type_id"
    t.integer  "budget_priority"
  end

  create_table "industry_categories_supplier_accounts", :id => false, :force => true do |t|
    t.integer  "industry_category_id"
    t.integer  "supplier_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industry_category_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitation_backgrounds", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "author_name"
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitation_formats", :force => true do |t|
    t.string   "name"
    t.integer  "format_number"
    t.string   "format_file_name"
    t.string   "format_content_type"
    t.integer  "format_file_size"
    t.datetime "format_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "user_account_id"
    t.text     "text"
    t.string   "background_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_format_id"
    t.integer  "invitation_background_id"
    t.string   "string_1"
    t.string   "string_2"
    t.string   "string_3"
    t.string   "string_4"
    t.string   "string_5"
    t.string   "string_6"
    t.string   "string_7"
  end

  create_table "invitee_groups", :force => true do |t|
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "invitee_hosts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitee_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitees", :force => true do |t|
    t.string   "name"
    t.string   "lastname_p"
    t.string   "lastname_m"
    t.string   "phone_number"
    t.string   "email"
    t.boolean  "confirmed",        :default => false
    t.integer  "gender_id"
    t.integer  "age_id"
    t.integer  "status_id"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitee_group_id"
    t.integer  "user_account_id"
    t.integer  "couple_id"
    t.integer  "invitee_host_id"
    t.integer  "invitee_role_id"
    t.integer  "invitation_id"
    t.boolean  "invitation_sent",  :default => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "conversation_id"
    t.string   "transmitter"
    t.text     "content"
    t.boolean  "user_read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "supplier_read"
    t.boolean  "is_supplier"
  end

  create_table "no_more_bookings", :force => true do |t|
    t.integer  "no_more_bookable_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "no_more_bookable_type"
  end

  create_table "payer_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payers", :force => true do |t|
    t.decimal  "percentage",    :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payer_type_id"
    t.integer  "expense_id"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "lastname_p"
    t.string   "lastname_m"
    t.string   "rut"
    t.string   "email"
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_images", :force => true do |t|
    t.string   "caption"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "industry_category_id"
  end

  add_index "posts", ["slug"], :name => "index_posts_on_slug"

  create_table "presentation_images", :force => true do |t|
    t.integer  "presentation_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "product_budgets", :force => true do |t|
    t.integer  "user_account_id"
    t.integer  "product_id"
    t.integer  "budget_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "included"
  end

  create_table "product_faqs", :force => true do |t|
    t.string   "question"
    t.string   "answer"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             :default => true
    t.integer  "image_index"
  end

  create_table "product_types", :force => true do |t|
    t.integer  "industry_category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "supplier_account_id"
    t.integer  "product_type_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price",                      :default => 0
    t.string   "price_description"
    t.integer  "top_price_range",            :default => 0
    t.integer  "industry_category_id"
    t.integer  "booking_resources_consumed", :default => 1
  end

  create_table "reference_requests", :force => true do |t|
    t.integer  "service_id"
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "supplier_account_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.text     "content"
    t.string   "reviewable_type"
    t.integer  "reviewable_id"
    t.boolean  "supplier_read",     :default => false
    t.integer  "user_id"
    t.boolean  "approved_by_admin", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rocks", :force => true do |t|
    t.integer  "gender_id"
    t.string   "sender_email"
    t.string   "recipient_email"
    t.string   "sender_name"
    t.string   "recipient_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_images", :force => true do |t|
    t.integer  "room_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             :default => true
    t.integer  "image_index"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "max_capacity"
    t.integer  "rent_cost"
    t.integer  "rent_type_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_day_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_days", :force => true do |t|
    t.integer  "day_id"
    t.integer  "schedule_id"
    t.time     "from"
    t.time     "to"
    t.boolean  "enabled"
    t.boolean  "all_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "start_lunch_time"
    t.time     "end_lunch_time"
    t.integer  "schedule_day_type_id"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_budgets", :force => true do |t|
    t.integer  "user_account_id"
    t.integer  "service_id"
    t.integer  "budget_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "included"
  end

  create_table "service_faqs", :force => true do |t|
    t.string   "question"
    t.string   "answer"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_images", :force => true do |t|
    t.integer  "service_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             :default => true
    t.integer  "image_index"
  end

  create_table "services", :force => true do |t|
    t.integer  "supplier_account_id"
    t.string   "address"
    t.string   "contact_phone"
    t.string   "commune"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "color_type_id"
    t.integer  "max_bookings",               :default => 3
    t.integer  "max_confirmed_bookings",     :default => 2
    t.string   "parking"
    t.boolean  "deliverable"
    t.string   "name"
    t.integer  "industry_category_id"
    t.text     "description"
    t.integer  "price",                      :default => 0
    t.string   "price_description"
    t.integer  "top_price_range",            :default => 0
    t.integer  "booking_resources_consumed", :default => 1
  end

  create_table "star_ratings", :force => true do |t|
    t.integer  "value"
    t.string   "rateable_type"
    t.integer  "rateable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "statuses", :force => true do |t|
    t.string   "status"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_accounts", :force => true do |t|
    t.integer  "supplier_id"
    t.string   "corporate_name"
    t.string   "web_page"
    t.string   "fantasy_name"
    t.string   "rut"
    t.string   "phone_number"
    t.string   "address"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved_by_us",            :default => false
    t.string   "public_url"
    t.boolean  "mail_sent",                 :default => false
    t.boolean  "approved_by_supplier",      :default => false
    t.boolean  "bookable",                  :default => true
    t.integer  "booking_resources",         :default => 3
    t.integer  "booking_waiting_list_size", :default => 5
  end

  create_table "supplier_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.integer  "contact_type_id"
    t.integer  "supplier_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_page_views", :force => true do |t|
    t.integer  "supplier_account_id"
    t.integer  "count"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "email",                                 :default => "",   :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language",                              :default => "es"
  end

  add_index "suppliers", ["email"], :name => "index_suppliers_on_email", :unique => true
  add_index "suppliers", ["reset_password_token"], :name => "index_suppliers_on_reset_password_token", :unique => true

  create_table "tentative_budgets", :force => true do |t|
    t.integer  "budget_range_id"
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", :force => true do |t|
    t.string   "question"
    t.string   "answer"
    t.integer  "ceremony_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trading_houses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_account_activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "comments"
    t.date     "done_by_date"
    t.boolean  "done"
    t.integer  "default_activity_id"
    t.integer  "user_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_account_images", :force => true do |t|
    t.integer  "user_account_id"
    t.string   "couple_file_name"
    t.string   "couple_content_type"
    t.integer  "couple_file_size"
    t.datetime "couple_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_account_trading_houses", :force => true do |t|
    t.integer  "user_account_id"
    t.integer  "trading_house_id"
    t.string   "trading_house_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "wedding_tentative_date"
    t.string   "wedding_city"
    t.boolean  "receive_news"
    t.boolean  "receive_supplier_promotions"
    t.boolean  "show_my_phones"
    t.boolean  "in_campaign",                 :default => false
    t.boolean  "did_review",                  :default => false
    t.integer  "budget_distribution_type_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.string   "language"
    t.integer  "user_account_id"
    t.boolean  "is_owner"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "videoable_type"
    t.integer  "videoable_id"
    t.string   "url_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wed_benchmarks", :force => true do |t|
    t.integer  "industry_category_id"
    t.decimal  "precentage",           :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
