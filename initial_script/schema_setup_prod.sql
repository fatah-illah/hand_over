-- ============================================
-- STEP 1: CONNECT TO MAIN DATABASE
-- ============================================
\c postgres

-- ============================================
-- STEP 2: CREATE DATABASE IF NOT EXISTS
-- ============================================
SELECT 'CREATE DATABASE lgsm_app'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'lgsm_app'
);
\gexec

-- ============================================
-- STEP 3: CREATE USERS
-- ============================================
DO $$ BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_super') THEN
        CREATE ROLE app_super WITH LOGIN PASSWORD 'mainsuper12345';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_be') THEN
        CREATE ROLE app_be WITH LOGIN PASSWORD 'mainbe12345';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app') THEN
        CREATE ROLE app WITH LOGIN PASSWORD 'main12345';
    END IF;
END $$;

-- ============================================
-- STEP 3.1: DEFAULT PRIVILEGES FOR FUTURE OBJECTS
-- ============================================
DO $$ 
BEGIN
    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_super GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_be';
    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_super GRANT SELECT, USAGE ON SEQUENCES TO app_be';

    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_super GRANT SELECT ON TABLES TO app';
END $$;

-- ============================================
-- STEP 4: SETUP OWNERSHIP
-- ============================================
ALTER DATABASE lgsm_app OWNER TO app_super;
GRANT CONNECT ON DATABASE lgsm_app TO app_be, app;

-- ============================================
-- STEP 5: CONNECT TO TARGET DB
-- ============================================
\c lgsm_app

-- ============================================
-- STEP 6: CREATE SCHEMAS
-- ============================================
CREATE SCHEMA IF NOT EXISTS sandbox AUTHORIZATION app_super;
CREATE SCHEMA IF NOT EXISTS jobportal AUTHORIZATION app_super;
CREATE SCHEMA IF NOT EXISTS shared_profile AUTHORIZATION app_super;

-- ============================================
-- STEP 7: CREATE SAMPLE TABLES
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
-- STEP 8: GRANT PRIVILEGES
-- ============================================
-- SCHEMA USAGE
GRANT USAGE ON SCHEMA sandbox, jobportal, shared_profile TO app_be, app;

-- app_be: full DML (CRUD)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sandbox TO app_be;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA jobportal TO app_be;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA shared_profile TO app_be;

GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA sandbox TO app_be;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA jobportal TO app_be;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA shared_profile TO app_be;

-- app: only SELECT
GRANT SELECT ON ALL TABLES IN SCHEMA sandbox TO app;
GRANT SELECT ON ALL TABLES IN SCHEMA jobportal TO app;
GRANT SELECT ON ALL TABLES IN SCHEMA shared_profile TO app;

-- Default privileges untuk future objects
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA sandbox
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA jobportal
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA shared_profile
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_be;

ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA sandbox
    GRANT SELECT ON TABLES TO app;
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA jobportal
    GRANT SELECT ON TABLES TO app;
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA shared_profile
    GRANT SELECT ON TABLES TO app;

ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA sandbox
    GRANT SELECT, USAGE ON SEQUENCES TO app_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA jobportal
    GRANT SELECT, USAGE ON SEQUENCES TO app_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_super IN SCHEMA shared_profile
    GRANT SELECT, USAGE ON SEQUENCES TO app_be;

-- ============================================
-- OPTIONAL: SECURITY
-- ============================================
-- REVOKE ALL ON DATABASE lgsm_app FROM PUBLIC;
-- REVOKE ALL ON SCHEMA sandbox, jobportal, shared_profile FROM PUBLIC;

-- how to run this script in local machine:
/* 
Production:
a. connect to bastion ssh tunnel:
ssh -i bastion-key.pem -N -L 6543:lgsm-rdspsql-db01.cv6q0ao8ubsx.ap-southeast-3.rds.amazonaws.com:5432 ec2-user@108.136.57.165
b. open another terminal and run psql:
psql -h localhost -d lgsm_app_prod -U postgres -p 6543 -f schema_setup.sql
and run again:
psql -h localhost -d lgsm_app -U app_super -p 6543 -f schema_setup.sql
*/
