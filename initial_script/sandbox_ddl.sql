-- Create schemas if they don't exist
CREATE SCHEMA IF NOT EXISTS sandbox;
CREATE SCHEMA IF NOT EXISTS jobportal;
CREATE SCHEMA IF NOT EXISTS shared_profile;

-- Create tables in sandbox schema
CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_comm_code_base" (
  "code_type" VARCHAR PRIMARY KEY,
  "code_type_name" VARCHAR NOT NULL,
  "is_active" BOOLEAN DEFAULT true NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "desc_attr1" VARCHAR,
  "desc_attr2" VARCHAR,
  "desc_attr3" VARCHAR,
  "desc_attr4" VARCHAR,
  "desc_attr5" VARCHAR,
  "desc_attr6" VARCHAR,
  "desc_attr7" VARCHAR,
  "desc_attr8" VARCHAR,
  "desc_attr9" VARCHAR,
  "desc_attr10" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_comm_code_base_upd_dttm_idx" ON "sandbox"."tb_sand_comm_code_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_comm_code_dtls" (
  "code_type" VARCHAR,
  -- "comm_code" VARCHAR UNIQUE,
  "comm_code" VARCHAR,
  "comm_code_name" VARCHAR NOT NULL,
  "order_index" INT NOT NULL,
  "is_active" BOOLEAN DEFAULT true NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "attr6" VARCHAR,
  "attr7" VARCHAR,
  "attr8" VARCHAR,
  "attr9" VARCHAR,
  "attr10" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_comm_code_dtls_pkey" PRIMARY KEY ("code_type", "comm_code")
);
CREATE INDEX IF NOT EXISTS "tb_sand_comm_code_dtls_upd_dttm_idx" ON "sandbox"."tb_sand_comm_code_dtls"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_base" (
  "user_id" VARCHAR PRIMARY KEY,
  "employee_id" VARCHAR UNIQUE NOT NULL,
  "username" VARCHAR UNIQUE,
  "personal_email" VARCHAR UNIQUE,
  "phone_number" VARCHAR UNIQUE,
  "password" VARCHAR,
  "status" VARCHAR NOT NULL,
  "activation_date" BIGINT,
  "failed_login_attempts" INT,
  "last_login_attempt" BIGINT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_base_upd_dttm_idx" ON "sandbox"."tb_sand_user_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_dtls" (
  "user_id" VARCHAR PRIMARY KEY,
  "full_name" VARCHAR,
  "working_email" VARCHAR UNIQUE,
  "birthdate" BIGINT,
  "domicile" VARCHAR,
  "emergency_contact" VARCHAR,
  "avtr_path" TEXT,
  "department" TEXT,
  "division" TEXT,
  "system" TEXT,
  "position" TEXT,
  "custom_groupings" TEXT,
  "mentor_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_dtls"("user_id"),
  "working_site" VARCHAR,
  "gender" VARCHAR,
  "joined_date" BIGINT,
  "korean_name" VARCHAR,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_user_dtls_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sandbox"."tb_sand_user_base"("user_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_dtls_upd_dttm_idx" ON "sandbox"."tb_sand_user_dtls"("upd_dttm");

-- CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_otp_base" (
--   "seq" BIGSERIAL PRIMARY KEY,
--   "user_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
--   "otp_code" VARCHAR NOT NULL,
--   "type_code" VARCHAR NOT NULL,
--   "purpose_code" VARCHAR NOT NULL,
--   "is_used" BOOLEAN,
--   "exp_dttm" BIGINT,
--   "attr1" VARCHAR,
--   "attr2" VARCHAR,
--   "attr3" VARCHAR,
--   "attr4" VARCHAR,
--   "attr5" VARCHAR,
--   "reg_by" VARCHAR,
--   "reg_dttm" BIGINT,
--   "upd_by" VARCHAR,
--   "upd_dttm" BIGINT,
--   "is_deleted" BOOLEAN DEFAULT false NOT NULL
-- );
-- CREATE INDEX IF NOT EXISTS "tb_sand_otp_base_upd_dttm_idx" ON "sandbox"."tb_sand_otp_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_status_log" (
  "seq" BIGINT,
  "user_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "old_status" VARCHAR,
  "new_status" VARCHAR,
  "reason" TEXT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_status_log_upd_dttm_idx" ON "sandbox"."tb_sand_user_status_log"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_login_attempt" (
  "attempt_id" VARCHAR PRIMARY KEY,
  "seq" BIGSERIAL,
  "user_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "attempt_dttm" BIGINT,
  "is_successful" BOOLEAN NOT NULL,
  "ip_address" VARCHAR,
  "user_agent" TEXT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_login_attempt_upd_dttm_idx" ON "sandbox"."tb_sand_login_attempt"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_login_streak" (
  "seq" INTEGER NOT NULL,
  "user_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "event_dttm" BIGINT,
  "event_type" VARCHAR,
  "current_streak" INTEGER,
  "longest_streak" INTEGER,
  "previous_streak" INTEGER,
  "last_successful_ip" VARCHAR,
  "last_user_agent" TEXT,
  "note" TEXT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_login_streak_pkey" PRIMARY KEY ("seq", "user_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_login_streak_upd_dttm_idx" ON "sandbox"."tb_sand_login_streak"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_group_category" (
  "group_cat" VARCHAR PRIMARY KEY,
  "description" TEXT,
  "is_classification" BOOLEAN DEFAULT false NOT NULL,
  "reference_code_type" VARCHAR,
  "is_active" BOOLEAN DEFAULT true NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_group_category_upd_dttm_idx" ON "sandbox"."tb_sand_group_category"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_group_base" (
  "group_cat" VARCHAR REFERENCES "sandbox"."tb_sand_group_category"("group_cat"),
  "group_name" VARCHAR UNIQUE,
  "description" TEXT,
  "reference_code" VARCHAR NOT NULL,
  "parent_group" VARCHAR NULL REFERENCES "sandbox"."tb_sand_group_base"("group_name"),
  "auto_assign" BOOLEAN DEFAULT false NOT NULL,
  "is_active" BOOLEAN DEFAULT true NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_group_base_pkey" PRIMARY KEY ("group_cat", "group_name")
);
CREATE INDEX IF NOT EXISTS "tb_sand_group_base_upd_dttm_idx" ON "sandbox"."tb_sand_group_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_group" (
  "user_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "group_name" VARCHAR,
  "is_primary" BOOLEAN DEFAULT false NOT NULL,
  "start_date" BIGINT,
  "end_date" BIGINT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_user_group_pkey" PRIMARY KEY ("user_id", "group_name")
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_group_upd_dttm_idx" ON "sandbox"."tb_sand_user_group"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_role_base" (
  "role_id" VARCHAR PRIMARY KEY,
  "category" VARCHAR,
  "role" VARCHAR UNIQUE NOT NULL,
  "description" TEXT,
  "is_default" BOOLEAN DEFAULT false,
  "is_system" BOOLEAN DEFAULT false,
  "order_index" INT NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_role_base_upd_dttm_idx" ON "sandbox"."tb_sand_role_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_role" (
  "user_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "role_id" VARCHAR REFERENCES "sandbox"."tb_sand_role_base"("role_id"),
  "is_primary" BOOLEAN DEFAULT false,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_user_role_pkey" PRIMARY KEY ("user_id", "role_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_role_upd_dttm_idx" ON "sandbox"."tb_sand_user_role"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_menu_base" (
  "menu_id" VARCHAR PRIMARY KEY,
  "menu_name" VARCHAR NOT NULL,
  "menu_cat" VARCHAR,
  "description" TEXT,
  "path" TEXT NOT NULL,
  "parent_id" VARCHAR NULL REFERENCES "sandbox"."tb_sand_menu_base"("menu_id"),
  "menu_level" INT NOT NULL,
  "order_index" INT,
  "is_displayed" BOOLEAN DEFAULT true NOT NULL,
  "is_active" BOOLEAN DEFAULT true NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_menu_base_upd_dttm_idx" ON "sandbox"."tb_sand_menu_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_role_menu_accs" (
  "role_id" VARCHAR REFERENCES "sandbox"."tb_sand_role_base"("role_id"),
  "menu_id" VARCHAR REFERENCES "sandbox"."tb_sand_menu_base"("menu_id"),
  -- "user_id" VARCHAR DEFAULT NULL REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "is_read" BOOLEAN DEFAULT false NOT NULL,
  "is_create" BOOLEAN DEFAULT false NOT NULL,
  "is_modify" BOOLEAN DEFAULT false NOT NULL,
  "is_delete" BOOLEAN DEFAULT false NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_role_menu_accs_pkey" PRIMARY KEY ("role_id", "menu_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_role_menu_accs_upd_dttm_idx" ON "sandbox"."tb_sand_role_menu_accs"("upd_dttm");

-- Profile details education table one-to-many (in shared_profile schema)
CREATE TABLE IF NOT EXISTS "shared_profile"."tb_profile_dtls_edu" (
  "user_id" VARCHAR NOT NULL,
  "seq" INT NOT NULL,
  "type" VARCHAR NOT NULL,
  "institution_name" VARCHAR,
  "degree" VARCHAR,
  "field_of_study" VARCHAR,
  "grade" VARCHAR,
  "description" TEXT,
  "certificate" VARCHAR,
  "start_date" BIGINT,
  "end_date" BIGINT,
  "issued_year" INT,
  "expired_year" INT,
  "is_expired" BOOLEAN DEFAULT false NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_profile_dtls_edu_pkey" PRIMARY KEY ("user_id", "seq")
);
CREATE INDEX IF NOT EXISTS "tb_profile_dtls_edu_upd_dttm_idx" ON "shared_profile"."tb_profile_dtls_edu"("upd_dttm");

-- Profile details career table one-to-many (in shared_profile schema)
CREATE TABLE IF NOT EXISTS "shared_profile"."tb_profile_dtls_career" (
  "user_id" VARCHAR NOT NULL,
  "seq" INT NOT NULL,
  "type" VARCHAR NOT NULL,
  "name" VARCHAR,
  "affiliation" VARCHAR,
  "position" VARCHAR,
  "employment_type" VARCHAR,
  "tech_stack" TEXT,
  "responsibility" TEXT,
  "start_date" BIGINT,
  "end_date" BIGINT,
  "is_still_there" BOOLEAN DEFAULT false NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_profile_dtls_career_pkey" PRIMARY KEY ("user_id", "seq")
);
CREATE INDEX IF NOT EXISTS "tb_profile_dtls_career_dttm_idx" ON "shared_profile"."tb_profile_dtls_career"("upd_dttm");

-- Skills table (in jobportal schema)
CREATE TABLE IF NOT EXISTS "jobportal"."tb_jobp_skill_base" (
  "skill_id" VARCHAR PRIMARY KEY,
  "type" VARCHAR NOT NULL,
  "skill_name" VARCHAR NOT NULL UNIQUE,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_jobp_skill_base_upd_dttm_idx" ON "jobportal"."tb_jobp_skill_base"("upd_dttm");

-- Profile details languages & skills table one-to-many (in shared_profile schema)
CREATE TABLE IF NOT EXISTS "shared_profile"."tb_profile_dtls_skill" (
  "user_id" VARCHAR NOT NULL,
  "seq" INT NOT NULL,
  "skill_id" VARCHAR NOT NULL REFERENCES "jobportal"."tb_jobp_skill_base"("skill_id"),
  "language_level" VARCHAR,
  "level_or_score" VARCHAR,
  "issuer" VARCHAR,
  "description" TEXT,
  "certificate_number" VARCHAR,
  "certificate" VARCHAR,
  "obtained_date" BIGINT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_profile_dtls_skill_pkey" PRIMARY KEY ("user_id", "seq")
);
CREATE INDEX IF NOT EXISTS "tb_profile_dtls_skill_dttm_idx" ON "shared_profile"."tb_profile_dtls_skill"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_badge_base" (
  "badge_code" VARCHAR PRIMARY KEY,
  "badge_name" VARCHAR NOT NULL,
  "description" TEXT,
  "badge_image_path" TEXT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_badge_base_upd_dttm_idx" ON "sandbox"."tb_sand_badge_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_course_base" (
  "course_id" VARCHAR PRIMARY KEY,
  "title" VARCHAR NOT NULL,
  "description" TEXT,
  "course_type" VARCHAR NOT NULL,
  "course_url" TEXT,
  "language" VARCHAR NOT NULL,
  "duration" DECIMAL(5,2) NOT NULL,
  "is_mandatory" BOOLEAN DEFAULT false NOT NULL,
  "pic" VARCHAR,
  "path" VARCHAR,
  "topic" VARCHAR,
  "has_assignment" BOOLEAN DEFAULT false,
  "has_quiz" BOOLEAN DEFAULT false,
  "points" DECIMAL(10,2),
  "badge_code" VARCHAR REFERENCES "sandbox"."tb_sand_badge_base"("badge_code"),
  "group_cat" VARCHAR,
  "group_name" VARCHAR,
  "display_yn" BOOLEAN DEFAULT true NOT NULL,
  "order_index" INT,
  "attr1" VARCHAR, -- UNIQUE,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_course_base_upd_dttm_idx" ON "sandbox"."tb_sand_course_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_course_material" (
  "course_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_course_base"("course_id"),
  "seq" INT NOT NULL,
  "material_type" VARCHAR NOT NULL,
  "material_path_or_url" TEXT,
  "description" TEXT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_course_material_pkey" PRIMARY KEY ("course_id", "seq")
);
CREATE INDEX IF NOT EXISTS "tb_sand_course_material_upd_dttm_idx" ON "sandbox"."tb_sand_course_material"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_course_enroll" (
  "enroll_id" VARCHAR PRIMARY KEY,
  "user_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "course_id" VARCHAR NOT NULL REFERENCES "sandbox"."tb_sand_course_base"("course_id"),
  "progress" DECIMAL(5,2),
  "status" VARCHAR,
  "points_earned" INT,
  "badge_earned" BOOLEAN DEFAULT false,
  "completion_date" BIGINT,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_course_enroll_upd_dttm_idx" ON "sandbox"."tb_sand_user_course_enroll"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_journey_base" (
  "journey_id" VARCHAR PRIMARY KEY,
  "name" VARCHAR NOT NULL,
  "description" TEXT,
  "journey_type" VARCHAR,
  "total_duration" DECIMAL(5,2),
  "mentor" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "group_cat" VARCHAR,
  "group_name" VARCHAR,
  "display_yn" BOOLEAN DEFAULT true NOT NULL,
  "points" DECIMAL(10,2),
  "badge_code" VARCHAR REFERENCES "sandbox"."tb_sand_badge_base"("badge_code"),
  "level" VARCHAR,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_journey_base_unique" UNIQUE ("journey_id", "journey_type", "level")
);
CREATE INDEX IF NOT EXISTS "tb_sand_journey_base_upd_dttm_idx" ON "sandbox"."tb_sand_journey_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_journey_course" (
  "journey_id" VARCHAR REFERENCES "sandbox"."tb_sand_journey_base"("journey_id"),
  "course_id" VARCHAR REFERENCES "sandbox"."tb_sand_course_base"("course_id"),
  "order_index" INT,
  "is_mandatory" BOOLEAN DEFAULT true NOT NULL,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_journey_course_pkey" PRIMARY KEY ("journey_id", "course_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_journey_course_upd_dttm_idx" ON "sandbox"."tb_sand_journey_course"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_journey_enroll" (
  "enroll_id" VARCHAR PRIMARY KEY,
  "user_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "journey_id" VARCHAR REFERENCES "sandbox"."tb_sand_journey_base"("journey_id"),
  "mentor" VARCHAR,
  "progress" DECIMAL(5,2),
  "status" VARCHAR,
  "points_earned" DECIMAL(10,2),
  "badge_earned" BOOLEAN DEFAULT false,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_journey_enroll_upd_dttm_idx" ON "sandbox"."tb_sand_user_journey_enroll"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_space_base" (
  "space_id" VARCHAR PRIMARY KEY,
  "space_type" VARCHAR,
  "owner_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "space_title" VARCHAR,
  "description" TEXT,
  "start_date_and_time" BIGINT,
  "end_date_and_time" BIGINT,
  "max_attendees" INT,
  "attendance_check" BOOLEAN DEFAULT true,
  "group_cat" VARCHAR,
  "group_name" VARCHAR,
  "space_status" VARCHAR,
  "location" VARCHAR,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX IF NOT EXISTS "tb_sand_space_base_upd_dttm_idx" ON "sandbox"."tb_sand_space_base"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_space_attendees" (
  "space_id" VARCHAR REFERENCES "sandbox"."tb_sand_space_base"("space_id"),
  "user_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "attendance_status" VARCHAR,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_space_attendees_pkey" PRIMARY KEY ("space_id", "user_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_space_attendees_upd_dttm_idx" ON "sandbox"."tb_sand_space_attendees"("upd_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_user_points" (
  "seq" integer NOT NULL,
	"user_id" varchar NOT NULL,
  "earned" DECIMAL(10,2) DEFAULT 0 NOT NULL,    -- point earned
  "remaining" DECIMAL(10,2) DEFAULT 0 NOT NULL,   -- remaining point
  "related_type" VARCHAR,     -- e.g. 'LOGIN_STREAK', COURSE', 'JOURNEY', 'BADGE', 'ADMIN_ADJUSTMENT', etc.
  "related_id" VARCHAR,       -- e.g. course_id, journey_id, badge_code, etc.
  "reason" TEXT,              -- optional free text reason
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_user_points_pkey" PRIMARY KEY ("user_id", "seq"),
	CONSTRAINT "tb_sand_user_points_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sandbox"."tb_sand_user_base"("user_id")
);
CREATE INDEX IF NOT EXISTS "tb_sand_user_points_user_id_idx" ON "sandbox"."tb_sand_user_points"("user_id");
CREATE INDEX IF NOT EXISTS "tb_sand_user_points_reg_dttm_idx" ON "sandbox"."tb_sand_user_points"("reg_dttm");

CREATE TABLE IF NOT EXISTS "sandbox"."tb_sand_email_tracking" (
  "seq" INTEGER NOT NULL,
  "user_id" VARCHAR REFERENCES "sandbox"."tb_sand_user_base"("user_id"),
  "email_address" VARCHAR,
  "type" VARCHAR,
  "status" VARCHAR,
  "error_message" TEXT,
  "response_code" VARCHAR,
  "attempt_count" INTEGER DEFAULT 1,
  "message_id" VARCHAR,
  "sent_at" BIGINT,
  "last_attempt_at" BIGINT,
  "metadata" JSONB,
  "attr1" VARCHAR,
  "attr2" VARCHAR,
  "attr3" VARCHAR,
  "attr4" VARCHAR,
  "attr5" VARCHAR,
  "reg_by" VARCHAR,
  "reg_dttm" BIGINT,
  "upd_by" VARCHAR,
  "upd_dttm" BIGINT,
  "is_deleted" BOOLEAN DEFAULT false NOT NULL,
  CONSTRAINT "tb_sand_email_tracking_pkey" PRIMARY KEY ("user_id", "seq")
);
CREATE INDEX IF NOT EXISTS "tb_sand_email_tracking_upd_dttm_idx" ON "sandbox"."tb_sand_email_tracking"("upd_dttm");
CREATE INDEX IF NOT EXISTS "tb_sand_email_tracking_user_id_idx" ON "sandbox"."tb_sand_email_tracking"("user_id");
CREATE INDEX IF NOT EXISTS "tb_sand_email_tracking_sent_at_idx" ON "sandbox"."tb_sand_email_tracking"("sent_at");
CREATE INDEX IF NOT EXISTS "tb_sand_email_tracking_type_idx" ON "sandbox"."tb_sand_email_tracking"("type");

-- Function for clear format
CREATE OR REPLACE FUNCTION "sandbox".clean_csv_format(input_text TEXT) 
RETURNS TEXT AS $$
BEGIN
    RETURN regexp_replace(
        regexp_replace(
            regexp_replace(
                trim(input_text),
                ',+$', ''     -- clear comma at the end
            ),
            ',+', ','        -- clear sequential commas
        ),
        ',\s*', ', '        -- space standardization after comma
    );
END;
$$ LANGUAGE plpgsql;

-- Helper Function for validation (comma-separated needed)
CREATE OR REPLACE FUNCTION "sandbox".validate_comm_codes(codes TEXT) 
RETURNS BOOLEAN AS $$
BEGIN
    -- Cross-check all values exist in reference table
    RETURN NOT EXISTS (
        SELECT 1
        FROM unnest(string_to_array(codes, ',')) AS code
        WHERE NOT EXISTS (
            SELECT 1 
            FROM "sandbox"."tb_sand_comm_code_dtls" 
            WHERE comm_code = trim(both ' ' from code)  -- Trim spaces from each code
        )
    );
END;
$$ LANGUAGE plpgsql;

-- Trigger to clear format and validate before insert or update
CREATE OR REPLACE FUNCTION "sandbox".validate_user_dtls_codes() 
RETURNS TRIGGER AS $$
BEGIN
    -- Clear format before validation
    NEW.department := "sandbox".clean_csv_format(NEW.department);
    NEW.division := "sandbox".clean_csv_format(NEW.division);
    NEW.system := "sandbox".clean_csv_format(NEW.system);
    NEW.position := "sandbox".clean_csv_format(NEW.position);
    NEW.custom_groupings := "sandbox".clean_csv_format(NEW.custom_groupings);
    
    -- Validation    
    IF NEW.department IS NOT NULL AND NOT "sandbox".validate_comm_codes(NEW.department) THEN
        RAISE EXCEPTION 'Invalid code in department';
    END IF;
    
    IF NEW.division IS NOT NULL AND NOT "sandbox".validate_comm_codes(NEW.division) THEN
        RAISE EXCEPTION 'Invalid code in division';
    END IF;
    
    IF NEW.system IS NOT NULL AND NOT "sandbox".validate_comm_codes(NEW.system) THEN
        RAISE EXCEPTION 'Invalid code in system';
    END IF;
    
    IF NEW.position IS NOT NULL AND NOT "sandbox".validate_comm_codes(NEW.position) THEN
        RAISE EXCEPTION 'Invalid code in position';
    END IF;

    IF NEW.custom_groupings IS NOT NULL AND NOT "sandbox".validate_comm_codes(NEW.custom_groupings) THEN
        RAISE EXCEPTION 'Invalid code in custom_groupings';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to invoke the validation function before insert or update
DROP TRIGGER IF EXISTS validate_user_dtls_codes_trigger ON "sandbox"."tb_sand_user_dtls";
CREATE TRIGGER validate_user_dtls_codes_trigger
BEFORE INSERT OR UPDATE ON "sandbox"."tb_sand_user_dtls"
FOR EACH ROW
EXECUTE FUNCTION "sandbox".validate_user_dtls_codes();


-- table to store the last date the sequence was used
CREATE TABLE IF NOT EXISTS sandbox.seq_tracker (
    seq_name TEXT PRIMARY KEY,
    last_used_date DATE
);

CREATE OR REPLACE FUNCTION sandbox.generate_id(p_prefix VARCHAR(4), p_seq_name VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
    today DATE := CURRENT_DATE;
    last_date DATE;
    date_part VARCHAR;
    seq_num VARCHAR(4);
BEGIN
    -- Check the last date the sequence was used
    SELECT st.last_used_date INTO last_date
    FROM sandbox.seq_tracker st
    WHERE st.seq_name = p_seq_name;

    IF last_date IS NULL OR last_date <> today THEN
        EXECUTE 'ALTER SEQUENCE ' || p_seq_name || ' RESTART WITH 1';

        INSERT INTO sandbox.seq_tracker(seq_name, last_used_date)
        VALUES (p_seq_name, today)
        ON CONFLICT (seq_name) DO UPDATE
        SET last_used_date = EXCLUDED.last_used_date;
    END IF;

    EXECUTE 'SELECT LPAD(NEXTVAL(''' || p_seq_name || ''')::TEXT, 4, ''0'')'
    INTO seq_num;

    date_part := TO_CHAR(today, 'YYMMDD');
    RETURN p_prefix || date_part || seq_num;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER;

CREATE OR REPLACE FUNCTION jobportal.generate_id(p_prefix VARCHAR(4), p_seq_name VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
    today DATE := CURRENT_DATE;
    last_date DATE;
    date_part VARCHAR;
    seq_num VARCHAR(4);
BEGIN
    -- Check the last date the sequence was used
    SELECT st.last_used_date INTO last_date
    FROM sandbox.seq_tracker st
    WHERE st.seq_name = p_seq_name;

    IF last_date IS NULL OR last_date <> today THEN
        EXECUTE 'ALTER SEQUENCE ' || p_seq_name || ' RESTART WITH 1';

        INSERT INTO sandbox.seq_tracker(seq_name, last_used_date)
        VALUES (p_seq_name, today)
        ON CONFLICT (seq_name) DO UPDATE
        SET last_used_date = EXCLUDED.last_used_date;
    END IF;

    EXECUTE 'SELECT LPAD(NEXTVAL(''' || p_seq_name || ''')::TEXT, 4, ''0'')'
    INTO seq_num;

    date_part := TO_CHAR(today, 'YYMMDD');
    RETURN p_prefix || date_part || seq_num;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER;


-- Create sequences (resetting daily) if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_user_base_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_user_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_role_base_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_role_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_menu_base_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_menu_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'jobportal' AND sequencename = 'seq_jobp_skill_base_id') THEN
        CREATE SEQUENCE "jobportal".seq_jobp_skill_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_course_base_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_course_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_journey_base_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_journey_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_course_enroll_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_course_enroll_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_journey_enroll_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_journey_enroll_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'sandbox' AND sequencename = 'seq_sand_space_base_id') THEN
        CREATE SEQUENCE "sandbox".seq_sand_space_base_id
            START WITH 1
            INCREMENT BY 1
            MAXVALUE 9999
            CYCLE
            CACHE 1;
    END IF;
END
$$;

-- Alter tables to use new ID format (only if not already set)
DO $$
BEGIN
    -- We need to check if the default is already set before trying to alter it
    -- This query might need adaptation depending on your PostgreSQL version
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_user_base' AND a.attname = 'user_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_user_base" 
            ALTER COLUMN user_id SET DEFAULT "sandbox".generate_id('USER', 'sandbox.seq_sand_user_base_id');
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_role_base' AND a.attname = 'role_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_role_base" 
            ALTER COLUMN role_id SET DEFAULT "sandbox".generate_id('ROLE', 'sandbox.seq_sand_role_base_id');
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_menu_base' AND a.attname = 'menu_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_menu_base" 
            ALTER COLUMN menu_id SET DEFAULT "sandbox".generate_id('MENU', 'sandbox.seq_sand_menu_base_id');
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'jobportal' AND c.relname = 'tb_jobp_skill_base' AND a.attname = 'skill_id'
    ) THEN
        ALTER TABLE "jobportal"."tb_jobp_skill_base" 
            ALTER COLUMN skill_id SET DEFAULT "jobportal".generate_id('SKLL', 'jobportal.seq_jobp_skill_base_id');
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_course_base' AND a.attname = 'course_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_course_base" 
            ALTER COLUMN course_id SET DEFAULT "sandbox".generate_id('CRSE', 'sandbox.seq_sand_course_base_id');
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_journey_base' AND a.attname = 'journey_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_journey_base" 
            ALTER COLUMN journey_id SET DEFAULT "sandbox".generate_id('JRNY', 'sandbox.seq_sand_journey_base_id');
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_user_course_enroll' AND a.attname = 'enroll_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_user_course_enroll" 
            ALTER COLUMN enroll_id SET DEFAULT "sandbox".generate_id('ENRL', 'sandbox.seq_sand_course_enroll_id');
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_user_journey_enroll' AND a.attname = 'enroll_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_user_journey_enroll" 
            ALTER COLUMN enroll_id SET DEFAULT "sandbox".generate_id('ENRL', 'sandbox.seq_sand_journey_enroll_id');
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM pg_attrdef ad 
        JOIN pg_class c ON ad.adrelid = c.oid 
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ad.adnum
        WHERE n.nspname = 'sandbox' AND c.relname = 'tb_sand_space_base' AND a.attname = 'space_id'
    ) THEN
        ALTER TABLE "sandbox"."tb_sand_space_base" 
            ALTER COLUMN space_id SET DEFAULT "sandbox".generate_id('SPCE', 'sandbox.seq_sand_space_base_id');
    END IF;
END
$$;


-- how to run this script in local machine:
/* 
1. Dev:
psql -h 10.124.36.5 -d lgsm_app_dev -U app_dev_super -f sandbox_ddl.sql
*/

/* 
2. QA:
a. connect to bastion ssh tunnel:
ssh -i qa-bastion-key.pem -N -L 6543:lgsm-qa-rdspsql-db01.cv6q0ao8ubsx.ap-southeast-3.rds.amazonaws.com:5432 ec2-user@16.78.79.221
b. open another terminal and run psql:
psql -h localhost -d lgsm_app_qa -U app_qa_super -p 6543 -f sandbox_ddl.sql
*/

/* 
3. Production:
a. connect to bastion ssh tunnel:
ssh -i bastion-key.pem -N -L 6543:lgsm-rdspsql-db01.cv6q0ao8ubsx.ap-southeast-3.rds.amazonaws.com:5432 ec2-user@108.136.57.165
b. open another terminal and run psql:
psql -h localhost -d lgsm_app -U app_super -p 6543 -f sandbox_ddl.sql
*/
