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

ActiveRecord::Schema.define(version: 20210227114212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.boolean  "active"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "role"
  end

  create_table "applications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "position_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "applications", ["position_id"], name: "index_applications_on_position_id", using: :btree
  add_index "applications", ["user_id"], name: "index_applications_on_user_id", using: :btree

  create_table "assessment_purchases", force: :cascade do |t|
    t.integer  "assessment_report_id"
    t.integer  "assessment_id"
    t.string   "charge_id"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "assessment_reports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "state"
    t.integer  "assessment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "assessments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.decimal  "price"
  end

  create_table "badge_types", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.string   "certificate_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "points"
    t.integer  "points_req"
    t.boolean  "awardable"
  end

  create_table "badges", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_type_id"
    t.integer  "year"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "best_practice_categories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "public"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "active_tab"
    t.boolean  "recommendable"
  end

  create_table "best_practices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "category"
    t.text     "emb_link"
    t.text     "ext_link"
    t.string   "documents"
    t.string   "audio"
    t.string   "link_title"
    t.text     "idea_help"
    t.integer  "best_practice_category_id"
    t.integer  "organization_id"
    t.boolean  "is_public"
    t.boolean  "got_point",                 default: false
    t.boolean  "anonymous"
  end

  create_table "certification_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "awardable"
  end

  create_table "certifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "certification_type_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "coach_action_plans", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "opportunity_application_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "goals"
    t.text     "participant_action_items"
    t.text     "coach_action_items"
    t.datetime "participant_deadlines"
    t.datetime "coach_deadlines"
    t.text     "success_indicators"
    t.text     "follow_up_meetings"
    t.string   "participant_name"
    t.integer  "participant_id"
    t.integer  "recommendation_application_id"
  end

  create_table "coach_action_plans_users", id: false, force: :cascade do |t|
    t.integer "coach_action_plan_id"
    t.integer "user_id"
    t.integer "participant_id"
  end

  create_table "collaboration_circles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "min_attendees"
    t.integer  "max_attendees"
    t.text     "expectations"
    t.string   "location_option"
    t.text     "location"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "meeting_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "facilitator_id"
  end

  create_table "collaboration_circles_users", id: false, force: :cascade do |t|
    t.integer "collaboration_circle_id"
    t.integer "user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
  end

  create_table "competencies", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  add_index "competencies", ["parent_id"], name: "index_competencies_on_parent_id", using: :btree

  create_table "competencies_question_groups", id: false, force: :cascade do |t|
    t.integer "competency_id"
    t.integer "question_group_id"
    t.string  "rating_bucket"
  end

  add_index "competencies_question_groups", ["competency_id"], name: "index_competencies_question_groups_on_competency_id", using: :btree
  add_index "competencies_question_groups", ["question_group_id"], name: "index_competencies_question_groups_on_question_group_id", using: :btree

  create_table "competencies_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "competency_id"
  end

  add_index "competencies_users", ["competency_id"], name: "index_competencies_users_on_competency_id", using: :btree
  add_index "competencies_users", ["user_id"], name: "index_competencies_users_on_user_id", using: :btree

  create_table "competency_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "competency_hierarchies", ["ancestor_id", "descendant_id"], name: "index_competency_hierarchies_on_ancestor_id_and_descendant_id", unique: true, using: :btree
  add_index "competency_hierarchies", ["descendant_id"], name: "index_competency_hierarchies_on_descendant_id", using: :btree

  create_table "coupon_uses", force: :cascade do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "assessment_report_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "organization_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "limit",           default: 0
  end

  create_table "delivery_competencies", force: :cascade do |t|
    t.integer  "opportunity_category_id"
    t.integer  "competency_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "developed_competencies", force: :cascade do |t|
    t.integer "competency_id"
    t.integer "opportunity_id"
    t.text    "description"
  end

  add_index "developed_competencies", ["competency_id"], name: "index_developed_competencies_on_competency_id", using: :btree
  add_index "developed_competencies", ["opportunity_id"], name: "index_developed_competencies_on_opportunity_id", using: :btree

  create_table "facilities", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "address"
    t.string   "map_location"
    t.string   "approval_name"
    t.string   "approval_mail"
  end

  add_index "facilities", ["state"], name: "index_facilities_on_state", using: :btree

  create_table "fast_content_departments", id: false, force: :cascade do |t|
    t.integer "fast_content_id"
    t.integer "department_id"
  end

  add_index "fast_content_departments", ["department_id"], name: "index_fast_content_departments_on_department_id", using: :btree
  add_index "fast_content_departments", ["fast_content_id"], name: "index_fast_content_departments_on_fast_content_id", using: :btree

  create_table "fast_contents", force: :cascade do |t|
    t.string   "topic"
    t.text     "description"
    t.text     "ext_link"
    t.text     "emb_link"
    t.string   "author"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "category_id"
    t.string   "documents"
    t.string   "audio"
    t.string   "images"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "link_title"
  end

  create_table "feedback_answers", force: :cascade do |t|
    t.text     "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "opportunity_id"
    t.integer  "creator_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "q1"
    t.integer  "q2"
    t.integer  "q3"
    t.integer  "q4"
    t.integer  "q5"
  end

  create_table "follows", force: :cascade do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "form_of_learnings", force: :cascade do |t|
    t.string   "name"
    t.boolean  "recommendable"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "group_admins", force: :cascade do |t|
    t.integer "group_id"
    t.integer "admin_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string   "title"
    t.integer  "naics_code"
    t.integer  "parent_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "naics_code_top"
  end

  add_index "industries", ["parent_id"], name: "index_industries_on_parent_id", using: :btree

  create_table "industry_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "industry_hierarchies", ["ancestor_id", "descendant_id"], name: "index_industry_hierarchies_on_ancestor_id_and_descendant_id", unique: true, using: :btree
  add_index "industry_hierarchies", ["descendant_id"], name: "index_industry_hierarchies_on_descendant_id", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "category"
    t.integer  "best_practice_category_id"
    t.string   "documents"
    t.boolean  "is_public",                 default: false
    t.boolean  "got_point",                 default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invites", force: :cascade do |t|
    t.string   "oid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "provider"
    t.datetime "completed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.string   "email"
  end

  add_index "invites", ["oid"], name: "index_invites_on_oid", using: :btree

  create_table "likes", force: :cascade do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "mentions", force: :cascade do |t|
    t.string   "mentioner_type"
    t.integer  "mentioner_id"
    t.string   "mentionable_type"
    t.integer  "mentionable_id"
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables", using: :btree
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions", using: :btree

  create_table "mentor_action_plans", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "opportunity_application_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "goals"
    t.text     "participant_action_items"
    t.text     "mentor_action_items"
    t.datetime "participant_deadlines"
    t.datetime "mentor_deadlines"
    t.text     "success_indicators"
    t.text     "follow_up_meetings"
    t.string   "participant_name"
    t.integer  "participant_id"
    t.integer  "recommendation_application_id"
  end

  create_table "mentor_action_plans_users", id: false, force: :cascade do |t|
    t.integer "mentor_action_plan_id"
    t.integer "user_id"
    t.integer "participant_id"
  end

  create_table "mentorship_circles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "min_mentees"
    t.integer  "max_mentees"
    t.text     "expectations"
    t.string   "location_option"
    t.text     "location"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
    t.integer  "mentor_id"
    t.integer  "user_id"
    t.string   "meeting_time"
    t.string   "mctype"
    t.integer  "numsessions"
    t.string   "frequency"
  end

  create_table "mentorship_circles_users", id: false, force: :cascade do |t|
    t.integer "mentorship_circle_id"
    t.integer "user_id"
  end

  create_table "meta_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string   "title"
    t.boolean  "internal"
    t.integer  "organization_id"
    t.integer  "industry_id"
    t.integer  "start_year"
    t.integer  "start_month"
    t.integer  "end_year"
    t.integer  "end_month"
    t.datetime "created_at",                                                                         null: false
    t.datetime "updated_at",                                                                         null: false
    t.integer  "min_hour"
    t.integer  "max_hour"
    t.text     "description"
    t.integer  "quantity"
    t.string   "city"
    t.string   "state"
    t.string   "department"
    t.integer  "owner_id"
    t.text     "learning_objectives"
    t.datetime "start_date"
    t.datetime "deadline_date"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "max_students"
    t.integer  "min_students"
    t.integer  "facility_id"
    t.integer  "opportunity_category_id"
    t.boolean  "approval_status",                                                    default: false
    t.string   "approval_code"
    t.integer  "opportunity_type_id"
    t.string   "webcast_id"
    t.string   "webcast_facilitator_id"
    t.text     "online_info"
    t.integer  "best_practice_category_id"
    t.string   "meeting_time"
    t.text     "location"
    t.geometry "lonlat",                    limit: {:srid=>4326, :type=>"st_point"}
  end

  add_index "opportunities", ["end_year", "end_month"], name: "index_opportunities_on_end_year_and_end_month", using: :btree
  add_index "opportunities", ["industry_id"], name: "index_opportunities_on_industry_id", using: :btree
  add_index "opportunities", ["organization_id"], name: "index_opportunities_on_organization_id", using: :btree
  add_index "opportunities", ["start_year", "start_month"], name: "index_opportunities_on_start_year_and_start_month", using: :btree

  create_table "opportunities_users", id: false, force: :cascade do |t|
    t.integer "opportunity_id"
    t.integer "user_id"
  end

  add_index "opportunities_users", ["opportunity_id"], name: "index_opportunities_users_on_opportunity_id", using: :btree
  add_index "opportunities_users", ["user_id"], name: "index_opportunities_users_on_user_id", using: :btree

  create_table "opportunity_application_types", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "opportunity_applications", force: :cascade do |t|
    t.integer  "opportunity_id"
    t.integer  "user_id"
    t.text     "reason_to_apply"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "opportunity_applications_type_id", default: 1
    t.integer  "foreign_key"
    t.boolean  "complete_plan",                    default: false
  end

  add_index "opportunity_applications", ["opportunity_id"], name: "index_opportunity_applications_on_opportunity_id", using: :btree
  add_index "opportunity_applications", ["user_id"], name: "index_opportunity_applications_on_user_id", using: :btree

  create_table "opportunity_categories", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "recommendable"
  end

  create_table "opportunity_coupon_uses", force: :cascade do |t|
    t.integer  "opportunity_coupon_id"
    t.integer  "user_id"
    t.integer  "opportunity_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "skill_type"
  end

  create_table "opportunity_coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "organization_id"
    t.boolean  "iscurrent",       default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "opportunity_purchases", force: :cascade do |t|
    t.integer  "opportunity_id"
    t.string   "charge_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "skill_type"
  end

  create_table "opportunity_scholarship_states", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "opportunity_scholarships", force: :cascade do |t|
    t.integer  "opportunity_id"
    t.integer  "user_id"
    t.text     "reason_to_apply"
    t.integer  "opportunity_scholarship_states_id", default: 1
    t.text     "reason_of_approval"
    t.integer  "approval_user_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "opportunity_scholarships", ["opportunity_id"], name: "index_opportunity_scholarships_on_opportunity_id", using: :btree
  add_index "opportunity_scholarships", ["user_id"], name: "index_opportunity_scholarships_on_user_id", using: :btree

  create_table "opportunity_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "description"
    t.integer  "company_size_min"
    t.integer  "company_size_max"
    t.string   "company_type"
    t.string   "website"
    t.integer  "industry_id"
    t.string   "operating_status"
    t.integer  "year_founded"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "oid"
    t.string   "provider"
    t.string   "avatar"
    t.string   "banner"
    t.boolean  "active_license"
    t.string   "salesforce_id"
    t.boolean  "has_chatter"
    t.integer  "user_licenses"
    t.text     "int_description"
    t.string   "domain"
    t.integer  "meta_group_id"
    t.string   "slug"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", using: :btree

  create_table "organizations_best_practice_categories", id: false, force: :cascade do |t|
    t.integer "best_practice_category_id"
    t.integer "organization_id"
  end

  add_index "organizations_best_practice_categories", ["best_practice_category_id"], name: "org_bp_categories", using: :btree
  add_index "organizations_best_practice_categories", ["organization_id"], name: "index_organizations_best_practice_categories_on_organization_id", using: :btree

  create_table "pac_members", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "pac_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "approved"
  end

  create_table "pacs", force: :cascade do |t|
    t.boolean  "complete"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "description"
    t.string   "webcast_id"
    t.string   "webcast_facilitator_id"
    t.integer  "opportunity_type_id"
    t.string   "category"
    t.text     "learning_objectives"
    t.datetime "start_date"
    t.datetime "deadline_date"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "max_students"
    t.integer  "min_students"
    t.integer  "facility_id"
    t.integer  "owner_id"
    t.string   "title"
    t.string   "city"
    t.string   "state"
    t.integer  "organization_id"
    t.boolean  "in_progress"
    t.string   "approval_code"
    t.boolean  "got_point",                 default: false
    t.boolean  "approval_status",           default: false
    t.text     "online_info"
    t.integer  "best_practice_category_id"
    t.boolean  "is_public",                 default: false
  end

  create_table "passions_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "passion_id"
  end

  add_index "passions_users", ["passion_id"], name: "index_passions_users_on_passion_id", using: :btree
  add_index "passions_users", ["user_id"], name: "index_passions_users_on_user_id", using: :btree

  create_table "points", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_type_id"
    t.integer  "year"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "position_type_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "position_type_hierarchies", ["ancestor_id", "descendant_id"], name: "p_t_hierarchies_ancestor_descent", unique: true, using: :btree
  add_index "position_type_hierarchies", ["descendant_id"], name: "p_t_hierarchies_descent", using: :btree

  create_table "position_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "position_types", ["parent_id"], name: "index_position_types_on_parent_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "question_groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "assessment_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "assessment_id"
    t.integer  "question_group_id"
  end

  add_index "questions", ["assessment_id"], name: "index_questions_on_assessment_id", using: :btree

  create_table "recommendation_applications", force: :cascade do |t|
    t.integer  "recommendation_id"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "application_message"
    t.boolean  "complete_plan",       default: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "user_id"
    t.boolean  "approval_status"
    t.integer  "opportunity_category_id"
    t.string   "con_strength"
    t.string   "con_engagement"
    t.string   "con_length"
    t.string   "con_type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "internal"
    t.integer  "end_year"
    t.integer  "end_month"
    t.string   "con_performance"
    t.string   "rec_type"
    t.text     "con_text"
  end

  create_table "related_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "group_id"
  end

  add_index "related_groups", ["group_id"], name: "index_group_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "single_user_license_purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_requests", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.text     "description"
    t.string   "issue_time"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", force: :cascade do |t|
    t.integer  "opportunity_id"
    t.integer  "creator_id"
    t.boolean  "approved"
    t.text     "body"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "likert_response"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "assessment_report_id"
  end

  add_index "user_answers", ["assessment_report_id"], name: "index_user_answers_on_assessment_report_id", using: :btree

  create_table "user_groups", force: :cascade do |t|
    t.integer "group_id"
    t.integer "member_id"
    t.boolean "approved",  default: false
  end

  create_table "user_license_purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "licenses_purchased"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "charge_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                   default: "",       null: false
    t.string   "encrypted_password",      default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "managed_organization_id"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "location"
    t.text     "description"
    t.string   "headline"
    t.string   "industry"
    t.integer  "organization_id"
    t.string   "access_key"
    t.string   "access_secret"
    t.string   "avatar"
    t.string   "role",                    default: "member", null: false
    t.integer  "interest_ids"
    t.string   "instance_url"
    t.string   "refresh_token"
    t.string   "old_salesforce_id"
    t.string   "encrypted_salesforce_id"
    t.string   "encrypted_access_key"
    t.string   "encrypted_uid"
    t.boolean  "active_license"
    t.date     "licensed_date"
    t.boolean  "mute_notifications",      default: false
    t.string   "invitation_token"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "invitation_created_at"
    t.boolean  "via_shopify"
    t.boolean  "hub_member"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["managed_organization_id"], name: "index_users_on_managed_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_interests", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "interest_id"
  end

  add_index "users_interests", ["interest_id"], name: "index_users_interests_on_interest_id", using: :btree
  add_index "users_interests", ["user_id"], name: "index_users_interests_on_user_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "title"
    t.boolean  "internal"
    t.text     "description"
    t.text     "embed_code"
    t.integer  "competency_ids"
    t.integer  "category"
    t.string   "learning_objectives"
    t.integer  "opportunity_category_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "volunteer_action_plans", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "opportunity_application_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "goals"
    t.text     "liason_action_items"
    t.text     "volunteer_action_items"
    t.datetime "liason_deadlines"
    t.datetime "volunteer_deadlines"
    t.text     "success_indicators"
    t.text     "follow_up_meetings"
    t.string   "liason_name"
    t.integer  "liason_id"
    t.integer  "recommendation_application_id"
  end

  create_table "volunteer_action_plans_users", id: false, force: :cascade do |t|
    t.integer "volunteer_action_plan_id"
    t.integer "user_id"
    t.integer "liason_id"
  end

  create_table "volunteer_circles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "min_attendees"
    t.integer  "max_attendees"
    t.text     "expectations"
    t.string   "location_option"
    t.text     "location"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "meeting_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organizer_id"
  end

  create_table "volunteer_circles_users", id: false, force: :cascade do |t|
    t.integer "volunteer_circle_id"
    t.integer "user_id"
  end

  create_table "webcast_facilitators", force: :cascade do |t|
    t.string   "email"
    t.string   "access_token"
    t.string   "organizer_key"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "zips", force: :cascade do |t|
    t.integer  "code"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.geometry "lonlat",     limit: {:srid=>4326, :type=>"st_point"}
  end

end
