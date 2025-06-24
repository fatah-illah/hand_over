-- ============================================
-- STEP 1: CONNECT TO MAIN DATABASE
-- ============================================
\c postgres

-- ============================================
-- STEP 2: CREATE DATABASE IF NOT EXISTS
-- ============================================
SELECT 'CREATE DATABASE lgsm_app_qa'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'lgsm_app_qa'
);
\gexec

-- ============================================
-- STEP 3: CREATE USERS
-- ============================================
DO $$ BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_qa_super') THEN
        CREATE ROLE app_qa_super WITH LOGIN PASSWORD 'qasuper12345';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_qa_be') THEN
        CREATE ROLE app_qa_be WITH LOGIN PASSWORD 'qabe12345';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_qa') THEN
        CREATE ROLE app_qa WITH LOGIN PASSWORD 'qa12345';
    END IF;
END $$;

-- ============================================
-- STEP 3.1: DEFAULT PRIVILEGES FOR FUTURE OBJECTS
-- ============================================
DO $$ 
BEGIN
    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_qa_be';
    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super GRANT SELECT, USAGE ON SEQUENCES TO app_qa_be';

    EXECUTE 'ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super GRANT SELECT ON TABLES TO app_qa';
END $$;

-- ============================================
-- STEP 4: SETUP OWNERSHIP
-- ============================================
ALTER DATABASE lgsm_app_qa OWNER TO app_qa_super;
GRANT CONNECT ON DATABASE lgsm_app_qa TO app_qa_be, app_qa;

-- ============================================
-- STEP 5: CONNECT TO TARGET DB
-- ============================================
\c lgsm_app_qa

-- ============================================
-- STEP 6: CREATE SCHEMAS
-- ============================================
CREATE SCHEMA IF NOT EXISTS sandbox AUTHORIZATION app_qa_super;
CREATE SCHEMA IF NOT EXISTS jobportal AUTHORIZATION app_qa_super;
CREATE SCHEMA IF NOT EXISTS shared_profile AUTHORIZATION app_qa_super;

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
GRANT USAGE ON SCHEMA sandbox, jobportal, shared_profile TO app_qa_be, app_qa;

-- app_qa_be: full DML (CRUD)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sandbox TO app_qa_be;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA jobportal TO app_qa_be;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA shared_profile TO app_qa_be;

GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA sandbox TO app_qa_be;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA jobportal TO app_qa_be;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA shared_profile TO app_qa_be;

-- app_qa: only SELECT
GRANT SELECT ON ALL TABLES IN SCHEMA sandbox TO app_qa;
GRANT SELECT ON ALL TABLES IN SCHEMA jobportal TO app_qa;
GRANT SELECT ON ALL TABLES IN SCHEMA shared_profile TO app_qa;

-- Default privileges untuk future objects
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA sandbox
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_qa_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA jobportal
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_qa_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA shared_profile
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_qa_be;

ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA sandbox
    GRANT SELECT ON TABLES TO app_qa;
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA jobportal
    GRANT SELECT ON TABLES TO app_qa;
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA shared_profile
    GRANT SELECT ON TABLES TO app_qa;

ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA sandbox
    GRANT SELECT, USAGE ON SEQUENCES TO app_qa_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA jobportal
    GRANT SELECT, USAGE ON SEQUENCES TO app_qa_be;
ALTER DEFAULT PRIVILEGES FOR ROLE app_qa_super IN SCHEMA shared_profile
    GRANT SELECT, USAGE ON SEQUENCES TO app_qa_be;

-- ============================================
-- OPTIONAL: KEAMANAN
-- ============================================
-- REVOKE ALL ON DATABASE lgsm_app_qa FROM PUBLIC;
-- REVOKE ALL ON SCHEMA sandbox, jobportal, shared_profile FROM PUBLIC;

-- how to run this script in local machine:
/* 
Production:
a. connect to bastion ssh tunnel:
ssh -i qa-bastion-key.pem -N -L 6543:lgsm-qa-rdspsql-db01.cv6q0ao8ubsx.ap-southeast-3.rds.amazonaws.com:5432 ec2-user@16.78.79.221
b. open another terminal and run psql:
psql -h localhost -d lgsm_app_qa -U postgres -p 6543 -f schema_setup.sql
and run again:
psql -h localhost -d lgsm_app_qa -U app_qa_super -p 6543 -f schema_setup.sql
*/
