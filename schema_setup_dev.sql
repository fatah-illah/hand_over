-- ============================================
-- STEP 1: CONNECT TO MAIN DATABASE
-- ============================================
\c postgres

-- ============================================
-- STEP 2: CREATE DATABASE IF NOT EXISTS
-- ============================================
SELECT 'CREATE DATABASE lgsm_app_dev'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'lgsm_app_dev'
);
\gexec

-- ============================================
-- STEP 3: CREATE USERS (ROLES WITH LOGIN)
-- ============================================
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_dev_super') THEN
        CREATE ROLE app_dev_super WITH LOGIN PASSWORD 'devsuper12345';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_dev') THEN
        CREATE ROLE app_dev WITH LOGIN PASSWORD 'dev12345';
    END IF;
END$$;

-- ============================================
-- STEP 3.1: SET DEFAULT PRIVILEGES BY SUPER
-- ============================================
DO $$ 
BEGIN
    -- Grant default privileges for future tables and sequences created by app_dev_super
    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_dev';
    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super GRANT SELECT, USAGE ON SEQUENCES TO app_dev';
END $$;

-- ============================================
-- STEP 4: SETUP DATABASE OWNERSHIP & ACCESS
-- ============================================
ALTER DATABASE lgsm_app_dev OWNER TO app_dev_super;
GRANT CONNECT ON DATABASE lgsm_app_dev TO app_dev;

-- ============================================
-- STEP 5: CONNECT TO TARGET DATABASE
-- ============================================
\c lgsm_app_dev

-- ============================================
-- STEP 6: CREATE SCHEMAS IF NOT EXISTS
-- ============================================
CREATE SCHEMA IF NOT EXISTS sandbox AUTHORIZATION app_dev_super;
CREATE SCHEMA IF NOT EXISTS jobportal AUTHORIZATION app_dev_super;
CREATE SCHEMA IF NOT EXISTS shared_profile AUTHORIZATION app_dev_super;

-- ============================================
-- STEP 7: CREATE TABLES
-- ============================================
CREATE TABLE IF NOT EXISTS sandbox.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jobportal.jobs (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shared_profile.user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    full_name VARCHAR(100),
    bio TEXT,
    profile_picture VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- STEP 8: GRANT PRIVILEGES TO DEV USER
-- ============================================
GRANT USAGE ON SCHEMA sandbox, jobportal, shared_profile TO app_dev;

-- Grant all privileges on all tables and sequences (existing)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sandbox TO app_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA jobportal TO app_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA shared_profile TO app_dev;

GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA sandbox TO app_dev;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA jobportal TO app_dev;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA shared_profile TO app_dev;

-- Set default privileges to apply automatically on future objects created by app_dev_super
ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super IN SCHEMA sandbox
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super IN SCHEMA jobportal
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super IN SCHEMA shared_profile
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_dev;

ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super IN SCHEMA sandbox
    GRANT SELECT, USAGE ON SEQUENCES TO app_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super IN SCHEMA jobportal
    GRANT SELECT, USAGE ON SEQUENCES TO app_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE app_dev_super IN SCHEMA shared_profile
    GRANT SELECT, USAGE ON SEQUENCES TO app_dev;

-- ============================================
-- STEP 9: (OPTIONAL) SECURITY HARDENING
-- ============================================
-- REVOKE ALL ON DATABASE lgsm_app_dev FROM app_dev;
-- REVOKE ALL ON SCHEMA sandbox, jobportal, shared_profile FROM app_dev;

-- how to run this script in local machine:
/* 
Production:
psql -h 10.124.36.5 -d postgres -U postgres -f schema_setup.sql
and run again:
psql -h 10.124.36.5 -d lgsm_app_dev -U app_super_dev -f schema_setup.sql
*/
