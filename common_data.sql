-- User Base
INSERT INTO sandbox.tb_sand_user_base (
    employee_id, username, personal_email, phone_number, "password",
    status, activation_date, failed_login_attempts, last_login_attempt,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT 
    '00000000', 'admin', '', '085173221600', 
    '$2a$10$1huAWAMsC/ozuQeKwIsgyeOnfAaL70pQjN5QIe3kAtIq0/aupVMHe',
    '02',
    extract(epoch FROM now()), -- activation_date
    0, 
    extract(epoch FROM now()), -- last_login_attempt
    NULL, NULL, NULL, NULL, NULL,
    'admin',
    extract(epoch FROM now()), -- reg_dttm
    'admin',
    extract(epoch FROM now()), -- upd_dttm
    false;

-- User Details
INSERT INTO sandbox.tb_sand_user_dtls (
    user_id, full_name, working_email, birthdate, domicile, emergency_contact, avtr_path,
    department, division, "system", "position", custom_groupings, mentor_id,
    working_site, gender, joined_date, korean_name,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT 
    (SELECT user_id FROM sandbox.tb_sand_user_base WHERE username = 'admin' LIMIT 1),
    'SUPER ADMIN', NULL, NULL, NULL, NULL, NULL,
    'GDC_DEP', NULL, NULL, NULL, NULL, NULL,
    NULL, 'M', NULL, NULL,
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false;

-- Role Base
INSERT INTO sandbox.tb_sand_role_base (
    category, "role", description, is_default, is_system, order_index,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
) VALUES
    ('ADM','REQUESTOR','Job Portal Requestor',false,false,0,NULL,NULL,NULL,NULL,NULL,'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),
    ('ADM','ADMIN','Administrative access',false,false,2,NULL,NULL,NULL,NULL,NULL,'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),
    ('USR','USER','General User',false,false,0,NULL,NULL,NULL,NULL,NULL,'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),
    ('ADM','HR','Human Resources Role',false,false,0,NULL,NULL,NULL,NULL,NULL,'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),
    ('ADM','LND','Learning and Development',false,false,0,NULL,NULL,NULL,NULL,NULL,'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false);

-- User Role
INSERT INTO sandbox.tb_sand_user_role (
    user_id, role_id, is_primary,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT 
    ub.user_id,
    rb.role_id,
    CASE rb.role WHEN 'ADMIN' THEN true ELSE false END,
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false
FROM sandbox.tb_sand_user_base ub
JOIN sandbox.tb_sand_role_base rb ON rb.role IN ('ADMIN', 'USER')
WHERE ub.username = 'admin';

-- Menu Base
-- Parent Menus
INSERT INTO sandbox.tb_sand_menu_base (
    menu_name, menu_cat, description, "path", parent_id, menu_level,
    order_index, is_displayed, is_active,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
) VALUES
    ('Users', 'ADM', 'Menu for user management', '/users', NULL, 1, 1, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),
    
    ('Learning Mgmt', 'ADM', 'Learning Management menu parent', '/learning-mgmt', NULL, 1, 4, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Dev Tools', 'ADM', 'Menu that contains dev tools like menu role mapping, common code', '/dev-tools', NULL, 1, 9, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Recruitment Mgmt', 'ADM', 'Main menu for recruitment management, including requisition, posting, and job details', '/recruitment-mgmt', NULL, 1, 8, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Home', 'USR', 'User''s Home Page', '/home', NULL, 1, 4, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Journey', 'USR', 'Menu to Enroll and Unenroll Journey and Courses', '/journey', NULL, 1, 5, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('My Journal', 'USR', 'Menu to see user''s own journal', '/my-journal', NULL, 1, 7, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Forum Group Discussion', 'ADM', 'A menu for group discussions between users in the form of a forum, supporting collaboration and knowledge sharing.', '/fgd', NULL, 1, 3, false, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Rewards', 'USR', 'Menu to see reward lists', '/rewards', NULL, 1, 9, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('User Profile', 'USR', 'User''s own profile page', '/user-profile', NULL, 1, 10, false, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Users', 'USR', 'Menu to display a list of users in the user interface context', '/Users', NULL, 1, 12, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false);

-- Child Menus
INSERT INTO sandbox.tb_sand_menu_base (
    menu_name, menu_cat, description, "path", parent_id, menu_level,
    order_index, is_displayed, is_active,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
) VALUES
    ('Empl. Mgmt', 'ADM', 'Employee management', '/empl-mgmt',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Users' and menu_cat='ADM'), 2, 1, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Job Posting', 'ADM', 'Menu for managing posted job vacancies', '/job-posting',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Recruitment Mgmt'), 2, 2, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Job Requisition', 'ADM', 'Menu for creating and managing recruitment requests', '/job-requisition',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Recruitment Mgmt'), 2, 1, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Courses', 'ADM', 'Menu to CRUD courses', '/learning-courses',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Learning Mgmt'), 2, 1, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Journey', 'ADM', 'Menu to CRUD Journey', '/learning-journey',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Learning Mgmt'), 2, 3, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Setting', 'ADM', 'Menu to set up common code for Learning Mgmt', '/setting',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Learning Mgmt'), 2, 4, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Internal Training', 'ADM', 'Menu for managing internal company training', '/internaltraining',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Learning Mgmt'), 2, 2, false, false,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), true),

    ('Role Map Mgmt', 'ADM', 'Menu to CRUD role and map it to menu', '/role-map-mgmt',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Dev Tools'), 2, 4, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Comm Code Mgmt', 'ADM', 'Menu to CRUD Common Code', '/cmcd-mgmt',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Dev Tools'), 2, 1, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

    ('Menu Mgmt', 'ADM', 'Menu to CRUD menu', '/menu-mgmt',
     (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Dev Tools'), 2, 3, true, true,
     NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false);

-- Level 3 Menus
INSERT INTO sandbox.tb_sand_menu_base (
    menu_name, menu_cat, description, "path", parent_id, menu_level,
    order_index, is_displayed, is_active,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
VALUES
('User Details', 'ADM', 'To show details of each user', '/user-details',
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Empl. Mgmt' AND menu_cat = 'ADM'),
 3, 1, false, true,
 NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

('Job Posting Detail', 'ADM', 'Job Detail for Job Posting', '/job-detail',
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Job Posting' AND menu_cat = 'ADM'),
 3, 2, false, true,
 NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

('Job Requisition Detail', 'ADM', 'Job Detail for Job Requisition', '/job-detail',
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Job Requisition' AND menu_cat = 'ADM'),
 3, 4, false, true,
 NULL, NULL, NULL, NULL, NULL, 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false);

-- Role Menu Access
INSERT INTO sandbox.tb_sand_role_menu_accs (
    role_id, menu_id, is_read, is_create, is_modify, is_delete,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
VALUES
-- Learning Mgmt
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Learning Mgmt'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Dev Tools
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Dev Tools'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Job Posting
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Job Posting'),
 false, false, false, false,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Job Requisition
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Job Requisition'),
 false, false, false, false,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Empl. Mgmt
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Empl. Mgmt'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- User Details
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'User Details'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Role Map Mgmt
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Role Map Mgmt'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Job Posting Detail
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Job Posting Detail'),
 false, false, false, false,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Job Requisition Detail
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Job Requisition Detail'),
 false, false, false, false,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Courses
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Courses'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Journey
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Journey' and menu_cat = 'ADM'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Setting
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Setting'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Home
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Home'),
 false, false, false, false,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Recruitment Mgmt
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Recruitment Mgmt'),
 false, false, false, false,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Comm Code Mgmt
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Comm Code Mgmt'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Menu Mgmt
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Menu Mgmt'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false),

-- Users
((SELECT role_id FROM sandbox.tb_sand_role_base WHERE role = 'ADMIN'),
 (SELECT menu_id FROM sandbox.tb_sand_menu_base WHERE menu_name = 'Users' and menu_cat= 'ADM'),
 true, true, true, true,
 NULL, NULL, NULL, NULL, NULL,
 'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false);

-- Users
INSERT INTO sandbox.tb_sand_role_menu_accs (
    role_id, menu_id, is_read, is_create, is_modify, is_delete,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT
    r.role_id,
    m.menu_id,
    CASE WHEN m.menu_name IN ('Journey', 'My Journal', 'User Profile') THEN true ELSE false END AS is_read,
    CASE WHEN m.menu_name IN ('Journey', 'My Journal', 'User Profile') THEN true ELSE false END AS is_create,
    CASE WHEN m.menu_name IN ('Journey', 'My Journal', 'User Profile') THEN true ELSE false END AS is_modify,
    CASE WHEN m.menu_name IN ('Journey', 'My Journal', 'User Profile') THEN true ELSE false END AS is_delete,
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false
FROM
    sandbox.tb_sand_role_base r
JOIN
    sandbox.tb_sand_menu_base m ON m.menu_cat = 'USR'
WHERE
    r.role = 'USER'
    AND m.menu_name IN (
        'Home',
        'Journey',
        'My Journal',
        'Rewards',
        'User Profile',
        'Users'
    );

INSERT INTO sandbox.tb_sand_role_menu_accs (
    role_id, menu_id, is_read, is_create, is_modify, is_delete,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT
    r.role_id,
    m.menu_id,
    true,  -- is_read
    true,  -- is_create
    true,  -- is_modify
    true,  -- is_delete
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false
FROM
    sandbox.tb_sand_role_base r
JOIN
    sandbox.tb_sand_menu_base m ON m.menu_cat = 'USR'
WHERE
    r.role = 'USER';

-- Recursive CTE to get all descendants of Recruitment Mgmt and Learning Mgmt
WITH RECURSIVE menu_hierarchy AS (
    SELECT menu_id, menu_name, parent_menu_id
    FROM sandbox.tb_sand_menu_base
    WHERE menu_name IN ('Recruitment Mgmt', 'Learning Mgmt')
    
    UNION ALL
    
    SELECT m.menu_id, m.menu_name, m.parent_menu_id
    FROM sandbox.tb_sand_menu_base m
    JOIN menu_hierarchy mh ON m.parent_menu_id = mh.menu_id
),
-- Menu for HR (all children of Recruitment Mgmt)
menu_hr AS (
    SELECT menu_id FROM menu_hierarchy
    WHERE EXISTS (
        SELECT 1 FROM sandbox.tb_sand_menu_base root
        WHERE root.menu_name = 'Recruitment Mgmt' AND root.menu_id = menu_hierarchy.parent_menu_id
        OR menu_hierarchy.menu_name = 'Recruitment Mgmt'
    )
),
-- Menu for LND (all children of Learning Mgmt)
menu_lnd AS (
    SELECT menu_id FROM menu_hierarchy
    WHERE EXISTS (
        SELECT 1 FROM sandbox.tb_sand_menu_base root
        WHERE root.menu_name = 'Learning Mgmt' AND root.menu_id = menu_hierarchy.parent_menu_id
        OR menu_hierarchy.menu_name = 'Learning Mgmt'
    )
),
-- Menu for REQUESTOR (only 2 specific menus)
menu_requestor AS (
    SELECT menu_id
    FROM sandbox.tb_sand_menu_base
    WHERE menu_name IN ('Job Requisition', 'Job Requisition Detail')
)

-- Insert for HR
INSERT INTO sandbox.tb_sand_role_menu_accs (
    role_id, menu_id, is_read, is_create, is_modify, is_delete,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT
    r.role_id, m.menu_id,
    true, true, true, true,
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false
FROM
    sandbox.tb_sand_role_base r
JOIN menu_hr m ON true
WHERE r.role = 'HR';

-- Insert for LND
INSERT INTO sandbox.tb_sand_role_menu_accs (
    role_id, menu_id, is_read, is_create, is_modify, is_delete,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT
    r.role_id, m.menu_id,
    true, true, true, true,
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false
FROM
    sandbox.tb_sand_role_base r
JOIN menu_lnd m ON true
WHERE r.role = 'LND';

-- Insert for REQUESTOR
INSERT INTO sandbox.tb_sand_role_menu_accs (
    role_id, menu_id, is_read, is_create, is_modify, is_delete,
    attr1, attr2, attr3, attr4, attr5,
    reg_by, reg_dttm, upd_by, upd_dttm, is_deleted
)
SELECT
    r.role_id, m.menu_id,
    true, true, true, true,
    NULL, NULL, NULL, NULL, NULL,
    'admin', extract(epoch FROM now()), 'admin', extract(epoch FROM now()), false
FROM
    sandbox.tb_sand_role_base r
JOIN menu_requestor m ON true
WHERE r.role = 'REQUESTOR';
